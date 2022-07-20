resource "kubernetes_namespace" "airbyte" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "airbyte"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

resource "aws_s3_bucket" "airbyte" {
  bucket         = var.airbyte_bucket
  acl            = "private"
  force_destroy  = true
}

data "aws_iam_role" "postgres" {
  name = "${var.cluster_name}-postgres"
}

resource "kubernetes_service_account" "postgres" {
  metadata {
    name      = "postgres-pod"
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = data.aws_iam_role.postgres.arn
    }
  }

  depends_on = [
    kubernetes_namespace.airbyte
  ]
}