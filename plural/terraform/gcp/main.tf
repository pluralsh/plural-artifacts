locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = "${local.gcp_location_parts[0]}-${local.gcp_location_parts[1]}"
}

data "google_client_config" "current" {}

data "google_container_cluster" "cluster" {
  name = var.cluster_name
  location = var.gcp_location
}

provider "kubernetes" {
  load_config_file = false
  host = data.google_container_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
  token = data.google_client_config.current.access_token
}


resource "google_service_account" "forge" {
  account_id = "forge-account"
  display_name = "Service account for forge"
}

resource "google_service_account_key" "forge" {
  service_account_id = google_service_account.forge.name
  public_key_type = "TYPE_X509_PEM_FILE"

  depends_on = [
    google_service_account.forge
  ]
}

resource "kubernetes_namespace" "forge" {
  metadata {
    name = var.plural_namespace
  }
}


resource "kubernetes_secret" "plural" {
  metadata {
    name = "plural-serviceaccount"
    namespace = kubernetes_namespace.plural.metadata[0].name
  }
  data = {
    "gcp.json" = base64decode(google_service_account_key.plural.private_key)
  }
}

resource "google_storage_bucket" "plural_bucket" {
  name = var.plural_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket" "plural_assets_bucket" {
  name = var.plural_assets_bucket
  project = var.gcp_project_id
  force_destroy = true
}


resource "google_storage_bucket" "plural_images_bucket" {
  name = var.plural_images_bucket
  project = var.gcp_project_id
  force_destroy = true
}

resource "google_storage_bucket_acl" "plural_bucket_acl" {
  bucket = google_storage_bucket.plural_bucket.name
  predefined_acl = "publicRead"
}

resource "google_storage_bucket_acl" "plural_assets_bucket_acl" {
  bucket = google_storage_bucket.plural_assets_bucket.name
  predefined_acl = "publicRead"
}

resource "google_storage_bucket_iam_member" "plural" {
  bucket = google_storage_bucket.plural_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.plural.email}"

  depends_on = [
    google_storage_bucket.plural_bucket,
    google_storage_bucket_acl.plural_bucket_acl
  ]
}

resource "google_storage_bucket_iam_member" "plural_assets" {
  bucket = google_storage_bucket.plural_assets_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.plural.email}"

  depends_on = [
    google_storage_bucket.plural_assets_bucket,
    google_storage_bucket_acl.plural_assets_bucket_acl
  ]
}


resource "google_storage_bucket_iam_member" "plural_images" {
  bucket = google_storage_bucket.plural_images_bucket.name
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.plural.email}"

  depends_on = [
    google_storage_bucket.plural_images_bucket
  ]
}