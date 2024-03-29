resource "kubernetes_namespace" "argo-workflows" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "argo-workflows"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_argo_workflows" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.argo_workflows.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:${var.namespace}:argo-workflows-server",
    "system:serviceaccount:*:${var.argo_workflows_serviceaccount}"
  ]
}

resource "aws_iam_policy" "argo_workflows" {
  name_prefix = "argo-workflows"
  description = "policy for argo workflows operator resources"
  policy      = data.aws_iam_policy_document.argo_workflows.json
}

resource "aws_s3_bucket" "argo_workflows" {
  bucket         = var.workflow_bucket
  acl            = "private"
  force_destroy  = var.force_destroy_bucket

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "argo_workflows" {
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
      "arn:aws:s3:::${var.workflow_bucket}",
      "arn:aws:s3:::${var.workflow_bucket}/*"
    ]
  }
}
