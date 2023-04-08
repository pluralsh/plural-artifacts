resource "kubernetes_namespace" "weaviate" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "weaviate"
    }
  }
}

module "weaviate-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-weaviate-sa"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "weaviate"
  roles               = ["roles/storage.admin"]
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"

  project_id            = var.project_id
  bucket_names          = [var.weaviate_bucket]
  service_account_email = module.weaviate-workload-identity.gcp_service_account_email
  location              = var.bucket_location
}

resource "kubernetes_service_account" "weaviate" {
  metadata {
    name      = "weaviate"
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.weaviate-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.weaviate
  ]
}
