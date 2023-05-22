resource "kubernetes_namespace" "yatai" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "yatai"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

resource "google_storage_bucket" "this" {
  name          = var.bucket
  project       = var.project_id
  force_destroy = true
  location      = var.bucket_location

  lifecycle {
    ignore_changes = [
      location,
    ]
  }
}

module "yatai_workload_identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-yatai-wi"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "default"
  roles               = var.roles

  depends_on = [
    kubernetes_namespace.yatai
  ]
}

resource "kubernetes_default_service_account" "default" {
  metadata {
    name      = "default"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.yatai_workload_identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.yatai
  ]
}

resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.this.name
  role   = "roles/storage.admin"
  #member = "serviceAccount:${google_service_account.this.email}"
  member = "serviceAccount:${module.yatai_workload_identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.this,
    module.yatai_workload_identity
  ]
}

resource "google_service_account" "this" {
  account_id   = "${var.cluster_name}-yatai"
  display_name = "Plural Yatai"
}

resource "google_storage_hmac_key" "this" {
  #service_account_email = google_service_account.this.email
  service_account_email = module.yatai_workload_identity.gcp_service_account_email
}

resource "google_service_account_key" "this" {
  #service_account_id = google_service_account.this.name
  service_account_id = module.yatai_workload_identity.gcp_service_account_email
}

resource "kubernetes_secret" "google_application_credentials" {
  metadata {
    name      = "yatai-gcp-credentials"
    namespace = var.namespace
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.this.private_key)
  }

  depends_on = [
    kubernetes_namespace.yatai
  ]
}
