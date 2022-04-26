resource "kubernetes_namespace" "dummy" {
  metadata {
    name = "gcp-config-connector"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "gcp-config-connector"
      "cnrm.cloud.google.com/system" = "true"
    }
    annotations = {
      "cnrm.cloud.google.com/version" = "1.82.0"
    }
  }
}

resource "kubernetes_namespace" "gcp-config-connector" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "gcp-config-connector"
      "cnrm.cloud.google.com/system" = "true"
    }
    annotations = {
      "cnrm.cloud.google.com/version" = "1.82.0"
    }
  }
}

resource "kubernetes_service_account" "gcp-cc" {
  metadata {
    name      = "cnrm-controller-manager"
    namespace = var.namespace
    annotations = {
      "cnrm.cloud.google.com/version" = "1.82.0"
      "iam.gke.io/gcp-service-account" = google_service_account.gcp-cc.email
    }
    labels = {
      "cnrm.cloud.google.com/system" = "true"
    }
  }

  depends_on = [
    kubernetes_namespace.gcp-config-connector
  ]
}

resource "google_service_account" "gcp-cc" {
  account_id   = "${var.cluster_name}-gcp-cc"
  display_name = "Plural GCP Config Connector"
}

resource "google_service_account_iam_member" "gcp-cc" {
  service_account_id = google_service_account.gcp-cc.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[${var.namespace}/cnrm-controller-manager]"
}

resource "google_project_iam_member" "gcp-cc" {
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.gcp-cc.email}"
  project = var.project_id
}

# module "gcp-cc-workload-identity" {
#   source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
#   name       = "${var.cluster_name}-gcp-config-connector"
#   namespace  = var.namespace
#   project_id = var.project_id
#   use_existing_k8s_sa = true
#   annotate_k8s_sa = false
#   k8s_sa_name = "cnrm-controller-manager"
#   roles = ["roles/owner"]
# }

resource "google_service_account_key" "gcp_config_connector_key" {
  service_account_id = google_service_account.gcp-cc.name
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "gcp-config-connector-credentials"
    namespace = var.namespace
  }

  data = {
    "key.json" = base64decode(google_service_account_key.gcp_config_connector_key.private_key)
  }

  depends_on = [
    kubernetes_namespace.gcp-config-connector
  ]
}
