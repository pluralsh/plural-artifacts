resource "kubernetes_namespace" "loki" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "loki"

    }
  }
}

module "loki-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-loki"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = var.loki_serviceaccount
  roles = []
  depends_on = [
    kubernetes_namespace.loki
  ]
}

resource "kubernetes_service_account" "loki" {
  metadata {
    name      = var.loki_serviceaccount
    namespace = var.namespace
    annotations = {
      "iam.gke.io/gcp-service-account" = module.loki-workload-identity.gcp_service_account_email
    }
  }

  depends_on = [
    kubernetes_namespace.loki
  ]
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"
  bucket_names = [var.loki_bucket]
  service_account_email = module.loki-workload-identity.gcp_service_account_email
  project_id = var.project_id
}
