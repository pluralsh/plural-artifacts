resource "kubernetes_namespace" "chatwoot" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "chatwoot"
    }
  }
}

locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = "${local.gcp_location_parts[0]}-${local.gcp_location_parts[1]}"
}

resource "kubernetes_service_account" "chatwoot" {
  metadata {
    name      = var.chatwoot_serviceaccount
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.chatwoot-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.chatwoot
  ]
}

resource "google_storage_bucket" "chatwoot" {
  name = var.chatwoot_bucket
  project = var.project_id
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "chatwoot" {
  bucket = google_storage_bucket.chatwoot.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.chatwoot-workload-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.chatwoot,
  ]
}

module "chatwoot-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-chatwoot"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = var.chatwoot_serviceaccount
  roles = []
}
