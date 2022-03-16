resource "kubernetes_namespace" "airbyte" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "airbyte"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

resource "google_storage_bucket" "airbyte_bucket" {
  name = var.airbyte_bucket
  project = var.project_id
  force_destroy = true
  location = var.bucket_location
}

resource "google_storage_bucket_iam_member" "airbyte" {
  bucket = google_storage_bucket.airbyte_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.airbyte.email}"

  depends_on = [
    google_storage_bucket.airbyte_bucket,
    google_service_account.airbyte
  ]
}

resource "google_service_account" "airbyte" {
  account_id   = "${var.cluster_name}-airbyte"
  display_name = "Plural Airbyte"
}

resource "google_storage_hmac_key" "airbyte" {
  service_account_email = google_service_account.airbyte.email
}

resource "google_service_account_key" "airbyte_key" {
  service_account_id = google_service_account.airbyte.name
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "airbyte-gcp-credentials"
    namespace = var.namespace
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.airbyte_key.private_key)
  }

  depends_on = [
    kubernetes_namespace.airbyte
  ]
}