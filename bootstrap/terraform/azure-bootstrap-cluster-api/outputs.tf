output "cluster" {
  value = var.cluster_api ? merge(one(data.azurerm_kubernetes_cluster.cluster[*]), {
    host=one(data.azurerm_kubernetes_cluster.cluster[*]).kube_config.0.host,
    client_certificate=one(data.azurerm_kubernetes_cluster.cluster[*]).kube_config.0.client_certificate,
    client_key=one(data.azurerm_kubernetes_cluster.cluster[*]).kube_config.0.client_key,
    cluster_ca_certificate=one(data.azurerm_kubernetes_cluster.cluster[*]).kube_config.0.cluster_ca_certificate
  }) : one(module.aks[*])
  sensitive = true
}

output "plural_msi" {
  value = azurerm_user_assigned_identity.msi
}

output "kubelet_msi_id" {
  value = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*].kubelet_identity.0.client_id) : one(module.aks[*].kubelet_identity[0].client_id)
}

output "node_resource_group" {
  value = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*].node_resource_group) : one(data.azurerm_resource_group.node_group[*].name)
}

output "cluster_name" {
  value = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*].name) : one(module.aks[*].cluster_name)
}

output "resource_group_name" {
  value = data.azurerm_resource_group.group.name
}

output "network" {
  value = one(module.network[*])
}
