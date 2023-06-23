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

variable "input_string" {
  type    = string
  default = "example-string-to-be-shortened"
}


module "sentry_workload_identity" {
  count  = local.sentry_sa_len
  source = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name   = "${var.cluster_name}-sentry-${substr(split("-", var.sentry_serviceaccount_suffixes[count.index])[0], 0, 5)}-${length(split("-", var.sentry_serviceaccount_suffixes[count.index])) > 1 ? substr(split("-", var.sentry_serviceaccount_suffixes[count.index])[length(split("-", var.sentry_serviceaccount_suffixes[count.index])) - 1], 0, 5) : ""}"
  #name                = "${var.cluster_name}-sentry-${var.sentry_serviceaccount_suffixes[count.index]}"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_gcp_sa = false
  use_existing_k8s_sa = false
  annotate_k8s_sa     = true
  k8s_sa_name         = "sentry-${var.sentry_serviceaccount_suffixes[count.index]}"
  roles               = []
}


#resource "kubernetes_service_account" "service_accounts" {
#  count = local.sentry_sa_len
#  metadata {
#    name      = "sentry-${var.sentry_serviceaccount_suffixes[count.index]}"
#    namespace = var.namespace
#    annotations = {
#      "iam.gke.io/gcp-service-account" = module.sentry_workload_identity[count.index].gcp_service_account_email
#    }
#  }
#
#  depends_on = [
#    kubernetes_namespace.sentry,
#    module.sentry_workload_identity
#  ]
#}

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
  member = "serviceAccount:${module.sentry_workload_identity[count.index].gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.filestore_bucket,
    module.sentry_workload_identity
  ]
}
