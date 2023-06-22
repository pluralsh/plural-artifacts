locals {
  namespace     = "sentry"
  sentry_sa_len = length(var.sentry_serviceaccount_suffixes)
}

resource "kubernetes_namespace" "sentry" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by"   = "plural"
      "app.plural.sh/name"             = "sentry"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

module "sentry_workload_identity" {
  count               = local.sentry_sa_len
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-sentry-${var.sentry_serviceaccount_suffixes[count.index]}"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "sentry-${var.sentry_serviceaccount_suffixes[count.index]}"
  roles               = []
}


resource "kubernetes_service_account" "service_accounts" {
  count = local.sentry_sa_len
  metadata {
    name      = "sentry-${var.sentry_serviceaccount_suffixes[count.index]}"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.sentry_workload_identity[count.index].gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.sentry,
    module.sentry_workload_identity
  ]
}

resource "google_storage_bucket" "filestore_bucket" {
  name          = var.filestore_bucket
  project       = var.project_id
  force_destroy = true
  location      = var.bucket_location

  lifecycle {
    ignore_changes = [
      location,
    ]
  }
}

resource "google_storage_bucket_iam_member" "filestore" {
  count  = local.sentry_sa_len
  bucket = google_storage_bucket.filestore_bucket.name
  role   = "roles/storage.admin"
  member = "serviceAccount:${module.sentry_workflow_identity[count.index].gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.symbolicator_bucket,
    module.sentry_workload_identity
  ]
}
