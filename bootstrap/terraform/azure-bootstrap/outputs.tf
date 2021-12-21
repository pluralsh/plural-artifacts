output "cluster" {
  value = module.aks
  sensitive = true
}

output "kubelet_msi_id" {
  value = module.aks.kubelet_identity[0].client_id
}

output "node_resource_group" {
  value = data.azurerm_resource_group.node_group.name
}