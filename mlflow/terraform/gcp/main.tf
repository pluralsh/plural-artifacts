resource "kubernetes_namespace" "mlflow" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by"   = "plural"
      "app.plural.sh/name"             = "mlflow"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

module "mlflow-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-${var.role_name}"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = var.serviceaccount_name
  roles               = []
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"

  project_id            = var.project_id
  location              = var.bucket_location
  bucket_names          = [var.mlflow_bucket]
  service_account_email = module.mlflow-workload-identity.gcp_service_account_email
}

#resource "kubernetes_service_account" "mlflow" {
#  metadata {
#    name      = var.serviceaccount_name
#    namespace = var.namespace
#    annotations = {
#      "iam.gke.io/gcp-service-account" = module.mlflow-workload-identity.gcp_service_account_email
#    }
#  }
#
#  depends_on = [
#    kubernetes_namespace.mlflow
#  ]
#}
