resource "kubernetes_namespace" "cube" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "cube"

    }
  }
}

module "cube_bucket-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-cube-sa"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "cube"
  roles               = ["roles/storage.admin"]
}


resource "google_service_account_key" "gcp_config_connector_key" {
  service_account_id = module.cube_bucket-workload-identity.gcp_service_account_email
}

resource "kubernetes_secret" "google-application-credentials" {
  metadata {
    name = "cube-gcp-credentials"
    namespace = var.namespace
  }

  data = {
    "key.json" = google_service_account_key.gcp_config_connector_key.private_key
  }

  depends_on = [
    kubernetes_namespace.cube
  ]
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"

  project_id            = var.project_id
  bucket_names          = [var.cube_bucket]
  service_account_email = module.cube_bucket-workload-identity.gcp_service_account_email
  location              = var.bucket_location
}
