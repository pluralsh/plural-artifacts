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

resource "google_storage_bucket_iam_member" "this" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.this.email}"

  depends_on = [
    google_storage_bucket.this,
    google_service_account.this
  ]
}

resource "google_service_account" "this" {
  account_id   = "${var.cluster_name}-yatai"
  display_name = "Plural Yatai"
}

resource "google_storage_hmac_key" "this" {
  service_account_email = google_service_account.this.email
}

resource "google_service_account_key" "this" {
  service_account_id = google_service_account.this.name
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name      = "yatai-gcp-credentials"
    namespace = var.namespace
  }

  data = {
    "credentials.json" = base64decode(google_service_account_key.this.private_key)
  }

  depends_on = [
    kubernetes_namespace.airbyte
  ]
}

module "yatai-workload-identity-yatai" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-yatai-wi-yatai"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "yatai"
  roles               = var.roles

  depends_on = [
    kubernetes_namespace.yatai
  ]
}

# TODO: let's see if I can get away with just one gcp service account
#module "yatai-workload-identity-yatai-deployment" {
#  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
#  name                = "${var.cluster_name}-yatai-wi-yatai-deployment"
#  namespace           = var.namespace
#  project_id          = var.project_id
#  use_existing_k8s_sa = true
#  annotate_k8s_sa     = false
#  k8s_sa_name         = "yatai-deployment"
#  roles               = var.roles
#
#  depends_on = [
#    kubernetes_namespace.yatai
#  ]
#}
#
#module "yatai-workload-identity-yatai-image-builder" {
#  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
#  name                = "${var.cluster_name}-yatai-wi-yatai-image-builder"
#  namespace           = var.namespace
#  project_id          = var.project_id
#  use_existing_k8s_sa = true
#  annotate_k8s_sa     = false
#  k8s_sa_name         = "yatai-image-builder"
#  roles               = var.roles
#
#  depends_on = [
#    kubernetes_namespace.yatai
#  ]
#}

module "yatai-workload-identity-default" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-yatai-wi-default"
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
      "iam.gke.io/gcp-service-account" = module.yatai-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.yatai
  ]
}
