resource "kubernetes_namespace" "argo-workflows" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "argo-workflows"
    }
  }
}

resource "google_service_account" "argo-workflows" {
  account_id   = "${var.cluster_name}-argo-workflows"
  display_name = "Plural Argo Workflows"
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"

  project_id            = var.project_id
  bucket_names          = [var.workflow_bucket]
  service_account_email = google_service_account.argo-workflows.email
}