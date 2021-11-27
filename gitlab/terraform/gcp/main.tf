locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = "${local.gcp_location_parts[0]}-${local.gcp_location_parts[1]}"
}

resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
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

resource "google_storage_bucket" "registry_bucket" {
  name = var.registry_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "packages_bucket" {
  name = var.packages_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "artifacts_bucket" {
  name = var.artifacts_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "backups_bucket" {
  name = var.backups_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "backups_tmp_bucket" {
  name = var.backups_tmp_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "lfs_bucket" {
  name = var.lfs_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "runner_cache" {
  name = var.runner_cache_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "terraform_bucket" {
  name = var.terraform_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "registry" {
  bucket = google_storage_bucket.registry_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.registry_bucket,
  ]
}

resource "google_storage_bucket_iam_member" "packages" {
  bucket = google_storage_bucket.packages_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.packages_bucket,
  ]
}

resource "google_storage_bucket_iam_member" "artifacts" {
  bucket = google_storage_bucket.artifacts_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.artifacts_bucket,
  ]
}

resource "google_storage_bucket_iam_member" "backups" {
  bucket = google_storage_bucket.backups_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.backups_bucket,
  ]
}

resource "google_storage_bucket_iam_member" "backups_tmp" {
  bucket = google_storage_bucket.backups_tmp_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.backups_tmp_bucket,
  ]
}

resource "google_storage_bucket_iam_member" "lfs" {
  bucket = google_storage_bucket.lfs_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.lfs_bucket,
  ]
}

resource "google_storage_bucket_iam_member" "runner" {
  bucket = google_storage_bucket.runner_cache_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-runner-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.runner_cache_bucket,
  ]
}

resource "google_storage_bucket_iam_member" "terraform" {
  bucket = google_storage_bucket.terraform_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.gitlab-runner-workflow-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.terraform_bucket,
  ]
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