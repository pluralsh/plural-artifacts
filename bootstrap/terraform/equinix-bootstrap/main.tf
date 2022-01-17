provider "metal" {
  auth_token = var.auth_token
}

locals {
  ssh_key_name = "metal-key"
}

resource "random_id" "cloud" {
  byte_length = 8
}

resource "tls_private_key" "ssh_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "cluster_private_key_pem" {
  content         = chomp(tls_private_key.ssh_key_pair.private_key_pem)
  filename        = pathexpand(format("%s", local.ssh_key_name))
  file_permission = "0600"
}

resource "local_file" "cluster_public_key" {
  content         = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
  filename        = pathexpand(format("%s.pub", local.ssh_key_name))
  file_permission = "0600"
}

resource "metal_ssh_key" "kubernetes-on-metal" {
  name       = format("terraform-k8s-%s", random_id.cloud.b64_url)
  public_key = chomp(tls_private_key.ssh_key_pair.public_key_openssh)
}

resource "metal_reserved_ip_block" "api_server" {
  project_id = var.project_id
  # facility   = var.facility != "" ? var.facility : null
  metro      = var.metro
  quantity   = 1
  tags             = ["kubernetes", "control-plane-${var.cluster_name}", "kube-apiserver"]
}

resource "kubernetes_namespace" "bootstrap" {
  metadata {
    name = "bootstrap"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = var.namespace
    }
  }
  depends_on = [
    rke_cluster.cluster
  ]
}
