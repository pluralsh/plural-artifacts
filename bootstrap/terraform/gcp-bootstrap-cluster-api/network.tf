resource "google_compute_router" "router" {
  count   = var.migrated ? 0 : var.enable_nat ? 1 : 0
  name    = "${local.vpc_network_name}-router"
  region  = one(google_compute_subnetwork.vpc_subnetwork[*].region)
  network = one(google_compute_network.vpc_network[*].id)
}

resource "google_compute_address" "static_external_address" {
  count  = var.migrated ? 0 : var.enable_nat ? var.num_static_ips : 0
  name   = "${var.cluster_name}-static-ip"
  region = local.gcp_region
}

resource "google_compute_router_nat" "nat" {
  count                              = var.migrated ? 0 : var.enable_nat ? 1 : 0
  name                               = "${local.vpc_network_name}-nat"
  router                             = one(google_compute_router.router[*].name)
  region                             = one(google_compute_router.router[*].region)
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = one(google_compute_address.static_external_address[*].self_link)
  min_ports_per_vm                   = 64
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
