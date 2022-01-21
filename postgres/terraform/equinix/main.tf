terraform {
  required_providers {
    minio = {
      source = "pluralsh/minio"
      version = "1.1.3"
    }
  }
}

resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "postgres"
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

resource "minio_s3_bucket" "wal" {
  bucket = var.wal_bucket
  acl    = "private"
  force_destroy = true
}

data "minio_iam_policy_document" "postgres" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.wal_bucket}",
      "arn:aws:s3:::${var.wal_bucket}/*"
    ]
  }
}

resource "minio_iam_policy" "postgres" {
  name = "minio-postgres"
  policy    = data.minio_iam_policy_document.postgres.json

}

resource "minio_iam_user" "postgres" {
  name = "postgres"
}

resource "minio_iam_user_policy_attachment" "postgres" {
  user_name      = minio_iam_user.postgres.id
  policy_name = minio_iam_policy.postgres.id
}

resource "kubernetes_secret" "postgres_s3_secret" {
  metadata {
    name = "postgres-s3-secret"
    namespace = kubernetes_namespace.postgres.id
  }
  data = {
    "AWS_ACCESS_KEY_ID" = minio_iam_user.postgres.id
    "AWS_SECRET_ACCESS_KEY" = minio_iam_user.postgres.secret
  }
}
