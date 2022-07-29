resource "kubernetes_namespace" "mlflow" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "mlflow"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

module "s3_buckets" {
  source = "github.com/pluralsh/module-library//terraform/s3-buckets"
  bucket_names  = [var.mlflow_bucket]
  policy_prefix = "mlflow"
}

module "irsa_policy" {
  source = "github.com/pluralsh/module-library//terraform/irsa-policy"
  cluster_name   = var.cluster_name
  role_name      = var.role_name
  namespace      = var.namespace
  serviceaccount = var.serviceaccount_name
  policy_json    = data.aws_iam_policy_document.mlflow.json

}

data "aws_iam_policy_document" "mlflow" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.mlflow_bucket}",
      "arn:aws:s3:::${var.mlflow_bucket}/*"
    ]
  }
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
    kubernetes_namespace.mlflow
  ]
}
