terraform {
  required_providers {
    minio = {
      source  = "pluralsh/minio"
      version = "1.1.3"
    }
  }
}

resource "kubernetes_namespace" "yatai" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "yatai"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

data "kubernetes_secret" "minio" {
  metadata {
    name      = "minio-root-secret"
    namespace = var.minio_namespace
  }
}

provider "minio" {
  minio_server     = var.minio_server
  minio_region     = var.minio_region
  minio_access_key = data.kubernetes_secret.minio.data.rootUser
  minio_secret_key = data.kubernetes_secret.minio.data.rootPassword
  minio_ssl        = "true"
}

resource "minio_s3_bucket" "this" {
  bucket        = var.bucket
  acl           = "private"
  force_destroy = true
}

data "minio_iam_policy_document" "admin" {
  statement {
    sid     = "admin"
    effect  = "Allow"
    actions = ["s3:*"]

    resources = concat(
      [for bucket in var.bucket_names : "arn:aws:s3:::${bucket}"],
      [for bucket in var.bucket_names : "arn:aws:s3:::${bucket}/*"]
    )
  }
}

resource "minio_iam_policy" "admin" {
  name   = "minio-admin"
  policy = data.minio_iam_policy_document.this.json

}

resource "minio_iam_user" "user" {
  name = "yatai"
}

resource "minio_iam_user_policy_attachment" "this" {
  user_name   = minio_iam_user.user.id
  policy_name = minio_iam_policy.admin.id
}
