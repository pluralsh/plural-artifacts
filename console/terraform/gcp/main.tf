locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = "${local.gcp_location_parts[0]}-${local.gcp_location_parts[1]}"
}

resource "kubernetes_namespace" "console" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "console"
    }
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

  depends_on = [
    kubernetes_namespace.console
  ]
}

module "console-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-console"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = "console"
  roles = ["roles/owner", "roles/storage.admin"]
}