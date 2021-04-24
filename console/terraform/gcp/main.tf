locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = "${local.gcp_location_parts[0]}-${local.gcp_location_parts[1]}"
}

resource "google_service_account" "console" {
  account_id = "console-admin"
  display_name = "Service account for console"
}

resource "google_service_account_key" "console" {
  service_account_id = google_service_account.console.name
  public_key_type = "TYPE_X509_PEM_FILE"

  depends_on = [
    google_service_account.console
  ]
}

resource "google_project_iam_member" "console_admin" {
  project = var.gcp_project_id
  role    = "roles/owner"

  member = "serviceAccount:${google_service_account.console.email}"

  depends_on = [
    google_service_account.console,
  ]
}


resource "google_project_iam_member" "console_storage_admin" {
  project = var.gcp_project_id
  role    = "roles/storage.admin"

  member = "serviceAccount:${google_service_account.console.email}"

  depends_on = [
    google_service_account.console,
  ]
}

resource "kubernetes_namespace" "console" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_secret" "console" {
  metadata {
    name = "console-credentials"
    namespace = var.namespace
  }
  data = {
    "gcp.json" = base64decode(google_service_account_key.console.private_key)
  }

  depends_on = [
    kubernetes_namespace.console
  ]
}