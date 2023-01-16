resource "kubernetes_namespace" "dagster" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "dagster"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

resource "kubernetes_secret" "dagster_s3_secret" {
  metadata {
    name = "dagster-aws-env"
    namespace = kubernetes_namespace.dagster.id
  }

  // don't populate this yet
  data = {
    "AWS_ACCESS_KEY_ID" =  module.minio_buckets.access_key_id
    "AWS_SECRET_ACCESS_KEY" =  module.minio_buckets.secret_access_key
  }
}

module "minio_buckets" {
  source = "github.com/pluralsh/module-library//terraform/minio-buckets"

  minio_server    = var.minio_server
  minio_region    = var.minio_region
  minio_namespace = var.minio_namespace
  bucket_names    = [var.dagster_bucket]
  user_name       = "dagster"
}