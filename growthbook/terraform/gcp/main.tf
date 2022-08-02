resource "kubernetes_namespace" "growthbook" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "growthbook"
    }
  }
}

resource "google_service_account" "growthbook" {
  account_id   = "${var.cluster_name}-growthbook"
  display_name = "Plural Growthbook"
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"

  project_id            = var.project_id
  bucket_names          = [var.growthbook_bucket]
  service_account_email = google_service_account.growthbook.email
}

module "growthbook-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-growthbook"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = "growthbook"
  roles = []
}