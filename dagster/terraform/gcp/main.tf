resource "kubernetes_namespace" "dagster" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "dagster"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

resource "google_service_account" "dagster" {
  account_id   = "${var.cluster_name}-dagster"
  display_name = "Plural Dagster"
}

module "dagster-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = google_service_account.dagster.account_id
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  use_existing_gcp_sa = true 
  annotate_k8s_sa     = false
  k8s_sa_name         = "dagster"
  roles               = ["roles/storage.admin"]
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"

  project_id            = var.project_id
  bucket_names          = [var.dagster_bucket]
  service_account_email = google_service_account.dagster.email
}

resource "google_storage_hmac_key" "dagster" {
  service_account_email = google_service_account.dagster.email
}

resource "google_service_account_key" "dagster_key" {
  service_account_id = google_service_account.dagster.name
}

resource "kubernetes_secret" "dagster_s3_secret" {
  metadata {
    name = "dagster-aws-env"
    namespace = kubernetes_namespace.dagster.id
  }

  data = {
    "AWS_ACCESS_KEY_ID" = google_storage_hmac_key.dagster.access_id
    "AWS_SECRET_ACCESS_KEY" = google_storage_hmac_key.dagster.secret
    "GOOGLE_APPLICATION_CREDENTIALS" = base64decode(google_service_account_key.dagster_key.private_key)
  }
}
