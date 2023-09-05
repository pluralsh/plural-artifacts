data "azurerm_kubernetes_cluster" "cluster" {
  name = var.cluster_name
  resource_group_name = var.resource_group
}

data "azurerm_resource_group" "group" {
  name = var.resource_group
}

data "azurerm_dns_zone" "zone" {
  name = var.dns_zone_name
  resource_group_name = data.azurerm_resource_group.group.name
}

resource "azurerm_user_assigned_identity" "cert_manager" {
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location

  name = "${var.cluster_name}-cert-manager"
}

resource "azurerm_role_assignment" "rg-reader" {
  scope                = data.azurerm_resource_group.group.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.certmanager.principal_id
}

resource "azurerm_role_assignment" "dns-contributor" {
  scope                = data.azurerm_dns_zone.zone.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.cert_manager.principal_id
}

resource "azurerm_federated_identity_credential" "cert_manager" {
  name                = "${var.name}-cert-manager-federated-identity"
  resource_group_name = data.azurerm_resource_group.group.name
  audience            = ["api://AzureADTokenExchange"]
  issuer              = one(data.azurerm_kubernetes_cluster.cluster[*].oidc_issuer_url)
  parent_id           = azurerm_user_assigned_identity.cert_manager.id
  subject             = "system:serviceaccount:${var.namespace}:${var.serviceaccount_name}"
}
