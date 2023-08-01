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
