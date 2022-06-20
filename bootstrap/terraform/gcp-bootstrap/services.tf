
resource "google_project_service" "gcr" {
  project = var.gcp_project_id
  service = "artifactregistry.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}

resource "google_project_service" "container" {
  project = var.gcp_project_id
  service = "container.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project = var.gcp_project_id
  service = "iam.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}

resource "google_project_service" "storage" {
  project = var.gcp_project_id
  service = "storage.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}

resource "google_project_service" "dns" {
  project = var.gcp_project_id
  service = "dns.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  project = var.gcp_project_id
  service = "compute.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_on_destroy = false
}