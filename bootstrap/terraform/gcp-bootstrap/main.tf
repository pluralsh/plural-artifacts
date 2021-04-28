resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "vpc_subnetwork" {
  #name = "default-${var.gcp_cluster_region}"
  name = var.vpc_subnetwork_name

  ip_cidr_range = var.vpc_subnetwork_cidr_range

  network = google_compute_network.vpc_network.name

  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cluster_secondary_range_cidr
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.services_secondary_range_cidr
  }

  private_ip_google_access = true

  depends_on = [
    google_compute_network.vpc_network,
  ]
}

resource "google_container_cluster" "cluster" {
  location = var.gcp_location

  name = var.cluster_name

  min_master_version = "latest"

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.daily_maintenance_window_start_time
    }
  }

  # A set of options for creating a private cluster.
  private_cluster_config {
    enable_private_endpoint = false

    enable_private_nodes = false

    # master_ipv4_cidr_block = "${var.master_ipv4_cidr_block}"
  }

  # Configuration options for the NetworkPolicy feature.
  network_policy {
    # Whether network policy is enabled on the cluster. Defaults to false.
    # In GKE this also enables the ip masquerade agent
    # https://cloud.google.com/kubernetes-engine/docs/how-to/ip-masquerade-agent
    enabled = false
  }

  master_auth {
    # Setting an empty username and password explicitly disables basic auth
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  addons_config {
    http_load_balancing {
      disabled = var.http_load_balancing_disabled
    }

    network_policy_config {
      disabled = true
    }
  }

  network    = var.vpc_network_name
  subnetwork = var.vpc_subnetwork_name

  workload_identity_config {
    identity_namespace = "${var.gcp_project_id}.svc.id.goog"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = var.cluster_secondary_range_name
    services_secondary_range_name = var.services_secondary_range_name
  }

  remove_default_node_pool = true

  # The number of nodes to create in this cluster (not including the Kubernetes master).
  initial_node_count = 2

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block = var.master_authorized_networks_cidr_block
      display_name = var.master_authorized_networks_cidr_display
    }
  }

  timeouts {
    update = "20m"
  }

  depends_on = [
    google_compute_subnetwork.vpc_subnetwork,
  ]
}

resource "google_container_node_pool" "node_pool" {
  location = google_container_cluster.cluster.location

  count = length(var.node_pools)

  name = "${lookup(var.node_pools[count.index], "name", format("%03d", count.index + 1))}-pool"

  cluster = google_container_cluster.cluster.name

  initial_node_count = lookup(var.node_pools[count.index], "initial_node_count", 2)

  autoscaling {
    min_node_count = lookup(var.node_pools[count.index], "autoscaling_min_node_count", 2)
    max_node_count = lookup(var.node_pools[count.index], "autoscaling_max_node_count", 3)
  }

  management {
    auto_repair = lookup(var.node_pools[count.index], "auto_repair", true)
    auto_upgrade = lookup(var.node_pools[count.index], "auto_upgrade", true)
  }

  node_config {
    machine_type = lookup(var.node_pools[count.index], "node_config_machine_type", "n1-standard-1")

    disk_size_gb = lookup(var.node_pools[count.index], "node_config_disk_size_gb", 100)

    disk_type = lookup(var.node_pools[count.index], "node_config_disk_type", "pd-standard")

    preemptible = lookup(var.node_pools[count.index], "node_config_preemptible", false)

    workload_metadata_config {
      node_metadata = "GKE_METADATA_SERVER"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/servicecontrol"
    ]

    metadata = {
      # https://cloud.google.com/kubernetes-engine/docs/how-to/protecting-cluster-metadata
      disable-legacy-endpoints = "true"
    }
  }

  timeouts {
    update = "20m"
  }
}

resource "kubernetes_namespace" "bootstrap" {
  metadata {
    name = var.namespace
  }

  depends_on = [
    google_container_cluster.cluster
  ]
}

module "externaldns-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-externaldns"
  namespace  = var.namespace
  project_id = var.gcp_project_id
  roles = ["roles/dns.admin"]
}

resource "kubernetes_service_account" "console" {
  metadata {
    name      = "external-dns"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.externaldns-workload-identity.gcp_service_account_email
    }
  }
}