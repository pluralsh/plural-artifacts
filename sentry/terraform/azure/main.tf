resource "kubernetes_namespace" "console" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}

terraform {
  required_providers {
    minio = {
      source = "aminueza/minio"
      version = ">= 1.0.0"
    }
  }
  required_version = ">= 0.13"
}

provider "minio" {
  minio_server = var.minio_server
  minio_region = var.minio_region
  minio_access_key = var.minio_access_key
  minio_secret_key = var.minio_secret_key
  minio_ssl = "true"
}

resource "minio_s3_bucket" "filestore" {
  bucket = var.filestore_bucket
}

data "minio_iam_policy_document" "sentry" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.filestore_bucket}",
      "arn:aws:s3:::${var.filestore_bucket}/*"
    ]
  }
}
resource "minio_iam_policy" "sentry" {
  name = "minio-sentry"
  policy    = data.minio_iam_policy_document.sentry.json

}

resource "minio_iam_user" "sentry" {
  name = "sentry"
}

resource "minio_iam_user_policy_attachment" "sentry" {
  user_name      = minio_iam_user.sentry.id
  policy_name = minio_iam_policy.sentry.id
}

resource "kubernetes_secret" "sentry_s3_secret" {
  metadata {
    name = "sentry-s3-secret"
    namespace = kubernetes_namespace.sentry.id
  }
  data = {
    "AWS_ACCESS_KEY_ID" = minio_iam_user.sentry.id
    "AWS_SECRET_ACCESS_KEY" = minio_iam_user.sentry.secret
  }
}
