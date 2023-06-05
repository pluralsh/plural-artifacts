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

output "cluster_name" {
  value = module.aks.cluster_name
}

output "resource_group_name" {
  value = module.aks.resource_group_name
}

output "network" {
  value = module.network
}

output "generated_cluster_public_ssh_key" {
  value = module.aks.generated_cluster_public_ssh_key
}

output "generated_cluster_private_ssh_key" {
  value = module.aks.generated_cluster_private_ssh_key
}
