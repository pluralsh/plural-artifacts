resource "kubernetes_namespace" "chatwoot" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "chatwoot"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_chatwoot" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.chatwoot.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:${var.namespace}:${var.chatwoot_serviceaccount}"
  ]
}

resource "aws_iam_policy" "chatwoot" {
  name_prefix = "argo-workflows"
  description = "policy for argo workflows operator resources"
  policy      = data.aws_iam_policy_document.chatwoot.json
}

resource "aws_s3_bucket" "chatwoot" {
  bucket = var.chatwoot_bucket
  acl    = "private"
}

data "aws_iam_policy_document" "chatwoot" {
  statement {
    sid = "AllowListingBuckets"
    effect = "Allow"
    actions = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]
    resources = ["arn:aws:s3:::*"]
  }
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.chatwoot_bucket}",
      "arn:aws:s3:::${var.chatwoot_bucket}/*"
    ]
  }
}
