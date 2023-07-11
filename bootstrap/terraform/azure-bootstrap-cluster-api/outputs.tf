output "cluster" {
  value = var.cluster_api ? one(data.azurerm_kubernetes_cluster.cluster[*]) : one(module.aks[*])
  sensitive = true
}

output "kubelet_msi_id" {
  value = one(module.aks[*].kubelet_identity[0].client_id)
}

output "node_resource_group" {
  value = one(data.azurerm_resource_group.node_group[*].name)
}

output "cluster_name" {
  value = one(module.aks[*].cluster_name)
}

output "resource_group_name" {
  value = one(module.aks[*].resource_group_name)
}

output "network" {
  value = one(module.network[*])
}
