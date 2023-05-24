data "google_container_cluster" "cluster" {
  name = var.cluster_name
  location = var.gcp_region
}