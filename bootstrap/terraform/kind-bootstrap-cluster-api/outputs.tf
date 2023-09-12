output "cluster" {
  value = var.cluster_name
  sensitive = true
}

output "kubeconfig_path" {
  value = "${path.root}/kube_config_cluster.yaml"
}
