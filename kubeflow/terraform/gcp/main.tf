resource "kubernetes_namespace" "kubeflow" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kubeflow"
      "istio-injection" = "enabled"
    }
  }
}

resource "google_storage_bucket" "pipelines_bucket" {
  name = var.pipelines_bucket
  project = var.project_id
  force_destroy = true
  location = var.bucket_location

   lifecycle {
    ignore_changes = [
      location,
    ]
  }
}

resource "google_service_account" "kubeflow" {
  account_id   = "${var.cluster_name}-kubeflow-gcs"
  display_name = "Plural Kubeflow GCS ${var.cluster_name}"
}

resource "google_storage_bucket_iam_member" "kubeflow" {
  bucket = google_storage_bucket.pipelines_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.kubeflow.email}"

  depends_on = [
    google_storage_bucket.pipelines_bucket,
    google_service_account.kubeflow
  ]
}

resource "google_storage_hmac_key" "kubeflow" {
  service_account_email = google_service_account.kubeflow.email
}

resource "google_service_account_key" "kubeflow_key" {
  service_account_id = google_service_account.kubeflow.name
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "pipelines-s3-secret"
    namespace = kubernetes_namespace.kubeflow.id
  }

  data = {
    "username" = google_storage_hmac_key.kubeflow.access_id
    "password" = google_storage_hmac_key.kubeflow.secret
  }
}
