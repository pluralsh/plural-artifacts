resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "vault"

    }
  }
}

resource "kubernetes_service_account" "vault" {
  metadata {
    name      = var.vault_serviceaccount
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.vault-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.vault
  ]
}

resource "google_project_service" "kms" {
  project = var.project_id
  service = "cloudkms.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }
}

module "vault-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-vault"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = var.vault_serviceaccount
  roles = []
}

resource "google_kms_key_ring_iam_binding" "vault_iam_kms_binding" {
  key_ring_id = "${google_kms_key_ring.vault.id}"
  role = "roles/owner"

  members = [
    "serviceAccount:${module.vault-workload-identity.gcp_service_account_email}",
  ]
}

resource "google_kms_key_ring" "vault" {
  project  = "${var.project_id}"
  name     = "${var.cluster_name}-vault"
  location = "${var.keyring_location}"

  depends_on = [
    google_project_service.kms
  ]
}

resource "google_kms_crypto_key" "vault" {
  name            = "${var.cluster_name}-vault-key"
  key_ring        = "${google_kms_key_ring.vault.id}"
  rotation_period = "100000s"

  depends_on = [
    google_project_service.kms
  ]
}
