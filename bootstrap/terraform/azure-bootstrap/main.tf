data "azurerm_subscription" "sub" {
}

data "azurerm_resource_group" "group" {
  name = var.resource_group
}

data "azurerm_resource_group" "node_group" {
  name = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*].node_resource_group) : one(module.aks[*].node_resource_group)
}

data "azurerm_kubernetes_cluster" "cluster" {
  count = var.cluster_api ? 1: 0

  name = var.name
  resource_group_name = var.resource_group
}

data "azurerm_virtual_network" "vnet" {
  count = var.cluster_api ? 1: 0

  name                = var.network_name
  resource_group_name = var.resource_group
}

module "network" {
  count = var.cluster_api ? 0 : 1

  source = "github.com/pluralsh/terraform-azurerm-network?ref=plural"

  vnet_name           = var.network_name
  resource_group_name = data.azurerm_resource_group.group.name
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  subnet_names        = [var.subnet_name]
  tags                = var.tags
}

module "aks" {
  count = var.cluster_api ? 0 : 1

  source = "github.com/pluralsh/terraform-azurerm-aks?ref=ea5c22775e0352ef6fe7a9abe2d94306029b6a6e" # branch auto-scaler-profile

  resource_group_name              = data.azurerm_resource_group.group.name
  kubernetes_version               = var.kubernetes_version
  orchestrator_version             = var.kubernetes_version
  prefix                           = var.name
  cluster_name                     = var.name
  network_plugin                   = var.network_plugin
  vnet_subnet_id                   = one(module.network[*].vnet_subnets[0])
  os_disk_size_gb                  = var.node_groups[0].os_disk_size_gb
  os_disk_type                     = var.node_groups[0].os_disk_type
  enable_role_based_access_control = true
  rbac_aad_enabled                 = false
  rbac_aad_managed                 = false
  oidc_issuer_enabled              = true
  location                         = data.azurerm_resource_group.group.location
  sku_tier                         = "Standard"
  private_cluster_enabled          = var.private_cluster
  enable_http_application_routing  = false
  azure_policy_enabled             = false
  admin_username                   = var.admin_username
  enable_auto_scaling              = var.node_groups[0].enable_auto_scaling
  agents_min_count                 = var.node_groups[0].min_count
  agents_max_count                 = var.node_groups[0].max_count
  agents_count                     = var.node_groups[0].node_count  # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                  = var.node_groups[0].max_pods
  agents_pool_name                 = var.node_groups[0].name
  agents_availability_zones        = var.node_groups[0].availability_zones
  agents_type                      = "VirtualMachineScaleSets"
  agents_size                      = var.node_groups[0].vm_size

  agents_labels = var.node_groups[0].node_labels

  agents_tags = merge(var.node_groups[0].tags, var.tags)

  network_policy                 = var.network_policy
  net_profile_dns_service_ip     = "10.0.0.10"
  net_profile_docker_bridge_cidr = "170.10.0.1/16"
  net_profile_service_cidr       = "10.0.0.0/16"

  auto_scaler_profile_balance_similar_node_groups      = var.auto_scaler_profile_balance_similar_node_groups
  auto_scaler_profile_skip_nodes_with_local_storage    = var.auto_scaler_profile_skip_nodes_with_local_storage
  auto_scaler_profile_scale_down_utilization_threshold = var.auto_scaler_profile_scale_down_utilization_threshold

  enable_log_analytics_workspace = var.enable_aks_insights
  tags = var.tags

  depends_on = [module.network]
}

resource "azurerm_kubernetes_cluster_node_pool" "main" {
  for_each = var.cluster_api ? {} : {for idx, val in var.node_groups : val.name => val if idx != 0}

  kubernetes_cluster_id = one(module.aks[*].aks_id)

  name                  = each.value.name
  priority              = each.value.priority
  enable_auto_scaling   = each.value.enable_auto_scaling
  zones                 = each.value.availability_zones
  mode                  = each.value.mode
  orchestrator_version  = var.kubernetes_version
  node_count            = each.value.node_count
  min_count             = each.value.min_count
  max_count             = each.value.max_count
  spot_max_price        = each.value.spot_max_price
  eviction_policy       = each.value.eviction_policy
  vnet_subnet_id        = one(module.network[*].vnet_subnets[0])
  vm_size               = each.value.vm_size
  os_disk_type          = each.value.os_disk_type
  os_disk_size_gb       = each.value.os_disk_size_gb
  max_pods              = each.value.max_pods

  node_labels           = each.value.node_labels
  node_taints           = each.value.node_taints
  tags                  = merge(each.value.tags, var.tags)
}

resource "azurerm_role_assignment" "aks-network-identity-ssi" {
  scope                = var.cluster_api ? one(data.azurerm_virtual_network.vnet[*].id) : one(module.network[*].vnet_id)
  role_definition_name = "Network Contributor"
  principal_id         = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*].identity[0].principal_id) : one(module.aks[*].system_assigned_identity[0].principal_id)

  depends_on = [data.azurerm_virtual_network.vnet, data.azurerm_kubernetes_cluster.cluster, module.aks, module.network]
}

resource "azurerm_role_assignment" "aks-managed-identity" {
  count = var.cluster_api ? 0 : 1

  scope                = data.azurerm_resource_group.group.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = one(module.aks[*].kubelet_identity[0].object_id)

  depends_on = [module.aks]
}

resource "azurerm_role_assignment" "aks-network-identity-kubelet" {
  count = var.cluster_api ? 0 : 1

  scope                = one(module.network[*].vnet_id)
  role_definition_name = "Network Contributor"
  principal_id         = one(module.aks[*].kubelet_identity[0].object_id)

  depends_on = [module.aks, module.network]
}

resource "azurerm_role_assignment" "aks-vm-contributor" {
  count = var.cluster_api ? 0 : 1

  scope                = data.azurerm_resource_group.group.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = one(module.aks[*].kubelet_identity[0].object_id)

  depends_on = [module.aks]
}

resource "azurerm_role_assignment" "aks-node-managed-identity" {
  count = var.cluster_api ? 0 : 1

  scope                = data.azurerm_resource_group.node_group.id
  role_definition_name = "Managed Identity Operator"
  principal_id         = one(module.aks[*].kubelet_identity[0].object_id)

  depends_on = [module.aks]
}

resource "azurerm_role_assignment" "aks-node-vm-contributor" {
  count = var.cluster_api ? 0 : 1

  scope                = data.azurerm_resource_group.node_group.id
  role_definition_name = "Virtual Machine Contributor"
  principal_id         = one(module.aks[*].kubelet_identity[0].object_id)

  depends_on = [module.aks]
}

resource "azurerm_user_assigned_identity" "capz" {
  location            = data.azurerm_resource_group.group.location
  name                = "${var.name}-capz"
  resource_group_name = data.azurerm_resource_group.group.name
}

resource "azurerm_role_assignment" "rg-contributor" {
  scope                = data.azurerm_resource_group.group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.capz.principal_id
}

resource "azurerm_role_assignment" "node-rg-contributor" {
  scope                = data.azurerm_resource_group.node_group.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.capz.principal_id
}

resource "azurerm_federated_identity_credential" "capz" {
  name                = "${var.name}-capz-federated-identity"
  resource_group_name = data.azurerm_resource_group.group.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*].oidc_issuer_url) : one(module.aks[*].oidc_issuer_url)
  parent_id           = azurerm_user_assigned_identity.capz.id
  subject             = "system:serviceaccount:${var.namespace}:bootstrap-capz-capz-manager"
}

resource "azurerm_user_assigned_identity" "aso" {
  location            = data.azurerm_resource_group.group.location
  name                = "${var.name}-capz-aso"
  resource_group_name = data.azurerm_resource_group.group.name
}

resource "azurerm_role_assignment" "aso-sub-contributor" {
  scope                = data.azurerm_subscription.sub.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.aso.principal_id
}

resource "azurerm_federated_identity_credential" "aso" {
  name                = "${var.name}-aso-federated-identity"
  resource_group_name = data.azurerm_resource_group.group.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*].oidc_issuer_url) : one(module.aks[*].oidc_issuer_url)
  parent_id           = azurerm_user_assigned_identity.aso.id
  subject             = "system:serviceaccount:${var.namespace}:bootstrap-capz-aso-default"
}

resource "kubernetes_namespace" "bootstrap" {
  count = var.cluster_api ? 0 : 1

  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "bootstrap"
    }
  }

  depends_on = [module.aks.host]
}
