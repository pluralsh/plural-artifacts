locals {
  pods_cidr_name     = "${var.gcp_region}-${var.cluster_name}-pods"
  services_cidr_name = "${var.gcp_region}-${var.cluster_name}-services"
  vpc_network_name   = var.vpc_network_name != "" ? var.vpc_network_name : "${var.vpc_name_prefix}-network"
  vpc_subnetwork_name = var.vpc_subnetwork_name != "" ? var.vpc_subnetwork_name : "${var.vpc_name_prefix}-subnetwork"
}