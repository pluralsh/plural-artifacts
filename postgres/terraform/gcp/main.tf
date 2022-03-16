resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "postgres"
    }
  }
}

resource "google_storage_bucket" "postgres_bucket" {
  name = var.wal_bucket
  project = var.project_id
  force_destroy = true
  location = var.bucket_location
}

resource "google_storage_bucket_iam_member" "postgres" {
  bucket = google_storage_bucket.postgres_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.postgres.email}"

  depends_on = [
    google_storage_bucket.postgres_bucket,
    google_service_account.postgres
  ]
}

resource "google_service_account" "postgres" {
  account_id   = "${var.cluster_name}-postgres"
  display_name = "Plural ${var.cluster_name} postgres role"
}

resource "google_service_account_key" "postgres_key" {
  service_account_id = google_service_account.postgres.name
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "postgres-gcp-creds"
    namespace = var.namespace
    labels = {
      "platform.plural.sh/sync" = "pg"
    }
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.postgres_key.private_key)
  }

  depends_on = [
    kubernetes_namespace.postgres
  ]
}