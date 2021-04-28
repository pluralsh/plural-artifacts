locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = "${local.gcp_location_parts[0]}-${local.gcp_location_parts[1]}"
}

resource "kubernetes_namespace" "console" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_service_account" "console" {
  metadata {
    name      = "console"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.console-workload-identity.gcp_service_account_email
    }
  }
}

module "console-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-console"
  namespace  = var.namespace
  project_id = var.gcp_project_id
  roles = ["roles/owner", "roles/storage.admin"]
}