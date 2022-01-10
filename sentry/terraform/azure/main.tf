resource "kubernetes_namespace" "sentry" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "sentry"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

module "minio_buckets" {
  source = "github.com/pluralsh/module-library//terraform/minio-buckets"
  minio_server = var.minio_server
  minio_region = var.minio_region
  minio_namespace = var.minio_namespace
  bucket_names = [var.filestore_bucket]
  user_name = "sentry"
}
