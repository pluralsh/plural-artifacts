locals {
	gcp_location       = var.gcp_location
  gcp_location_parts = split("-", local.gcp_location)
  gcp_region         = "${local.gcp_location_parts[0]}-${local.gcp_location_parts[1]}"
  pods_cidr_name     = "${var.gcp_location}-${var.cluster_name}-pods"
  services_cidr_name = "${var.gcp_location}-${var.cluster_name}-services"
}