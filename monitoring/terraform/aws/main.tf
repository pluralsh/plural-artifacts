resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "monitoring"
      "istio-injection" = "disabled"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_loki" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.loki.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*:${var.loki_serviceaccount}",
    "system:serviceaccount:*:${var.loki_distributed_serviceaccount}"
  ]
}

resource "aws_iam_policy" "loki" {
  name_prefix = "loki"
  description = "policy for loki resources"
  policy      = data.aws_iam_policy_document.loki.json
}

resource "aws_s3_bucket" "loki" {
  bucket = var.loki_bucket
  acl    = "private"
}

data "aws_iam_policy_document" "loki" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.loki_bucket}",
      "arn:aws:s3:::${var.loki_bucket}/*"
    ]
  }
}
