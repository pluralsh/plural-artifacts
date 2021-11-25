resource "kubernetes_namespace" "mysql" {
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

module "assumable_role_mysql" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.16.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-mysql-operator"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.mysql.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*:${var.mysql_serviceaccount}",
    "system:serviceaccount:*:mysql-pod"
  ]
}

resource "aws_iam_policy" "mysql" {
  name_prefix = "mysql"
  description = "policy for mysql operator resources"
  policy      = data.aws_iam_policy_document.mysql.json
}

resource "aws_s3_bucket" "wal" {
  bucket = var.backup_bucket
  acl    = "private"
  force_destroy = true
}

data "aws_iam_policy_document" "mysql" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.backup_bucket}",
      "arn:aws:s3:::${var.backup_bucket}/*"
    ]
  }
}