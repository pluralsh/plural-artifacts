resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_airflow" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.airflow.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.airflow_serviceaccount}"]
}

resource "aws_iam_policy" "airflow" {
  name_prefix = "airflow"
  description = "policy for the plural admin airflow"
  policy      = data.aws_iam_policy_document.airflow.json
}

resource "aws_s3_bucket" "airflow" {
  bucket         = var.airflow_bucket
  acl            = "private"
  force_destroy  = true
}

data "aws_iam_policy_document" "airflow" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.airflow_bucket}",
      "arn:aws:s3:::${var.airflow_bucket}/*",
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
    kubernetes_namespace.airflow
  ]
}