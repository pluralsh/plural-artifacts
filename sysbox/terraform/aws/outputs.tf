output "ng_merged" {
  value = module.node_groups.ng_merged
}

output "ng_temp" {
  value = module.node_groups.ng_temp
}

output "ng_expanded" {
  value = module.node_groups.ng_expanded
}

output "user_data_kubelet_extra_args" {
  value = module.node_groups.user_data_kubelet_extra_args
}

output "kubelet_extra_args" {
  value = module.node_groups.kubelet_extra_args
}

output "k8s_labels" {
  value = module.node_groups.k8s_labels
}

output "k8s_taints" {
  value = module.node_groups.k8s_taints
}

output "private_key_id" {
  description = "Unique identifier for this resource: hexadecimal representation of the SHA1 checksum of the resource"
  value       = module.node_groups.private_key_id
}

output "private_key_openssh" {
  description = "Private key data in OpenSSH PEM (RFC 4716) format"
  value       = module.node_groups.private_key_openssh
  sensitive   = true
}

output "private_key_pem" {
  description = "Private key data in PEM (RFC 1421) format"
  value       = module.node_groups.private_key_pem
  sensitive   = true
}
