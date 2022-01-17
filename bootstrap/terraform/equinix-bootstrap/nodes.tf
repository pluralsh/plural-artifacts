data "template_file" "node-setup" {
  template = file("${path.module}/templates/node-setup.tpl")

  vars = {
    control_plane_vip        = metal_reserved_ip_block.api_server.network
    equinix_api_key          = var.auth_token
    equinix_project_id       = var.project_id
    loadbalancer             = "kube-vip://"
  }
}

resource "metal_device" "k8s_control_plane" {
  count            = var.control_plane_node_count
  hostname         = format("${var.cluster_name}-control-plane-%02d", count.index)
  operating_system = "ubuntu_20_04"
  plan             = var.control_plane_node_plan
  # facilities       = var.facility != "" ? [var.facility] : null
  metro            = var.metro
  user_data        = data.template_file.node-setup.rendered
  tags             = ["kubernetes", "control-plane-${var.cluster_name}"]

  billing_cycle = "hourly"
  project_id    = var.project_id

  depends_on = [
    metal_ssh_key.kubernetes-on-metal
  ]
}

resource "metal_device" "k8s_worker_x86" {
  count            = var.worker_node_count_x86
  hostname         = format("${var.cluster_name}-worker-x86-%02d", count.index)
  operating_system = "ubuntu_20_04"
  plan             = var.worker_node_plan_x86
  # facilities       = var.facility != "" ? [var.facility] : null
  metro            = var.metro
  user_data        = data.template_file.node-setup.rendered
  tags             = ["kubernetes", "pool-${var.cluster_name}-worker-x86"]

  billing_cycle = "hourly"
  project_id    = var.project_id

  depends_on = [
    metal_ssh_key.kubernetes-on-metal
  ]
}
