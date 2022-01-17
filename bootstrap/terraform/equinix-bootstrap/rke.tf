provider "rke" {
  log_file = "rke_debug.log"
}

# Create a new RKE cluster using arguments
resource "rke_cluster" "cluster" {
  cluster_name = var.cluster_name
  kubernetes_version = "${var.kubernetes_version}"
  ingress {
    provider = "none"
  }
  network {
    plugin = "calico"
  }
  monitoring {
    provider = "none"
  }
  authentication {
    sans = ["${metal_reserved_ip_block.api_server.network}"]
  }
  cloud_provider {
    name = "external"
  }

  dynamic "nodes" {
    for_each = metal_device.k8s_control_plane
    content {
      address = nodes.value.network.0.address
      user    = "root"
      role    = ["controlplane", "etcd"]
      ssh_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
      node_name = nodes.value.hostname
      hostname_override = nodes.value.hostname
    }
  }
  dynamic "nodes" {
    for_each = metal_device.k8s_worker_x86
    content {
      address = nodes.value.network.0.address
      user    = "root"
      role    = ["worker"]
      ssh_key = chomp(tls_private_key.ssh_key_pair.private_key_pem)
      node_name = nodes.value.hostname
      hostname_override = nodes.value.hostname
    }
  }
  upgrade_strategy {
      drain = true
      max_unavailable_worker = "20%"
      drain_input {
        ignore_daemon_sets = true
      }
  }
  depends_on = [
    tls_private_key.ssh_key_pair,
    metal_device.k8s_control_plane,
    metal_device.k8s_worker_x86
  ]
}

resource "local_file" "orig_kube_cluster_yaml" {
  filename = "${path.root}/orig_kube_config_cluster.yaml"
  content  = rke_cluster.cluster.kube_config_yaml
}
