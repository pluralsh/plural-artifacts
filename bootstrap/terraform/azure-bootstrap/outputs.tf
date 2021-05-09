output "cluster" {
  value = module.aks
  sensitive = true
}

output "externaldns_msi_client_id" {
  value = azurerm_user_assigned_identity.externaldns.client_id
}

output "externaldns_msi_id" {
  value = azurerm_user_assigned_identity.externaldns.id
}

output "kubelet_msi_id" {
  value = module.aks.kubelet_identity[0].client_id
}

output "node_resource_group" {
  value = data.azurerm_resource_group.node_group.name
}