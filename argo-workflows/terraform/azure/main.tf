resource "kubernetes_namespace" "argo-workflows" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "argo-workflows"
    }
  }
}

module "minio" {
  source = "github.com/pluralsh/module-library//terraform/minio-buckets"
  minio_server = var.minio_server
  minio_region = var.minio_region
  minio_namespace = var.minio_namespace
  bucket_names = [var.workflow_bucket]
  user_name = "argo-workflows"
}
