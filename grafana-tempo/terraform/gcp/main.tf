resource "kubernetes_namespace" "grafana-tempo" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "grafana-tempo"
    }
  }
}

resource "kubernetes_service_account" "grafana-tempo" {
  metadata {
    name      = "grafana-tempo"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.tempo-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.grafana-tempo
  ]
}

resource "google_storage_bucket" "tempo" {
  name = var.tempo_bucket
  project = var.project_id
  force_destroy = true
  location = var.bucket_location
}

resource "google_storage_bucket_iam_member" "tempo" {
  bucket = google_storage_bucket.tempo.name
  role = "roles/storage.admin"
  member = "serviceAccount:${module.tempo-workload-identity.gcp_service_account_email}"

  depends_on = [
    google_storage_bucket.tempo,
  ]
}

module "tempo-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-tempo"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = "grafana-tempo"
  roles = []
}
