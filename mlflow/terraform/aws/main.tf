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

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "s3_buckets" {
  source            = "github.com/pluralsh/module-library//terraform/s3-buckets?ref=bucket-protection"
  bucket_names      = [var.mlflow_bucket]
  policy_prefix     = var.role_name
  force_destroy     = var.force_destroy_bucket
  bucket_tags       = var.bucket_tags
  enable_versioning = var.enable_versioning
}

module "assumable_role_mlflow" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [module.s3_buckets.policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.serviceaccount_name}"]
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
