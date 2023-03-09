resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "gitlab"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}


module "gitlab-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-gitlab"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = "gitlab"
  roles = []
}

module "gitlab-runner-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-gitlab-runner"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = "gitlab-runner"
  roles = []
}

resource "kubernetes_service_account" "gitlab" {
  metadata {
    name      = "gitlab"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.gitlab-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.gitlab
  ]
}

resource "kubernetes_service_account" "gitlab_runner" {
  metadata {
    name      = "gitlab-runner"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.gitlab-runner-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.gitlab
  ]
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"

  project_id            = var.project_id
  location              = var.bucket_location
  bucket_names          = [
    var.registry_bucket,
    var.packages_bucket,
    var.artifacts_bucket,
    var.backups_bucket,
    var.backups_tmp_bucket,
    var.lfs_bucket,
    var.terraform_bucket,
  ]
  service_account_email = module.gitlab-workload-identity.gcp_service_account_email
}

resource "google_storage_bucket" "runner-cache" {
  name          = var.runner_cache_bucket
  project       = var.project_id
  location      = var.bucket_location
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "gitlab-access" {
  bucket = google_storage_bucket.runner-cache.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-workload-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.runner-cache,
  ]
}

resource "google_storage_bucket_iam_member" "runner-access" {
  bucket = google_storage_bucket.runner-cache.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-runner-workload-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.runner-cache,
  ]
}