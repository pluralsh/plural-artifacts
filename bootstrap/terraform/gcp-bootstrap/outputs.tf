
output "cluster" {
  value = google_container_cluster.cluster
}

output "cluster_name" {
  value = google_container_cluster.cluster.name
}

output "node_pool" {
  value = google_container_node_pool.node_pool.0.name
}