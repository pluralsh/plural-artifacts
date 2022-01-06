resource "kubernetes_namespace" "airbyte" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "airbyte"
    }
  }
}

data "kubernetes_secret" "minio" {
  metadata {
    name = "minio-root-secret"
    namespace = var.minio_namespace
  }
}

provider "minio" {
  minio_server = var.minio_server
  minio_region = var.minio_region
  minio_access_key = data.kubernetes_secret.minio.data.rootUser
  minio_secret_key = data.kubernetes_secret.minio.data.rootPassword
  minio_ssl = "true"
}

resource "minio_s3_bucket" "airbyte" {
  bucket = var.airbyte_bucket
}

data "minio_iam_policy_document" "airbyte" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.airbyte_bucket}",
      "arn:aws:s3:::${var.airbyte_bucket}/*"
    ]
  }
}

resource "minio_iam_policy" "airbyte" {
  name = "minio-airbyte"
  policy    = data.minio_iam_policy_document.airbyte.json

}

resource "minio_iam_user" "airbyte" {
  name = "airbyte"
}

resource "minio_iam_user_policy_attachment" "airbyte" {
  user_name   = minio_iam_user.airbyte.id
  policy_name = minio_iam_policy.airbyte.id
}