resource "kubernetes_namespace" "postgres" {
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

module "assumable_role_postgres" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.postgres.arn]
  oidc_subjects_with_wildcards = ["system:serviceaccount:*:${var.postgres_serviceaccount}"]
}

resource "aws_iam_policy" "postgres" {
  name_prefix = "postgres"
  description = "policy for postgres operator resources"
  policy      = data.aws_iam_policy_document.postgres.json
}

resource "aws_s3_bucket" "wal" {
  bucket = var.wal_bucket
  acl    = "private"
}

data "aws_iam_policy_document" "postgres" {
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