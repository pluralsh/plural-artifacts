resource "kubernetes_namespace" "velero" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "velero"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_velero" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.velero.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*:${var.velero_serviceaccount}"
  ]
}

resource "aws_iam_access_key" "velero" {
  user    = aws_iam_user.velero.name
}

# create iam user(s) with full s3 permissions
resource "aws_iam_user" "velero" {
  name          = "velero"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "attach_s3_full_access" {
  user       = aws_iam_user.velero.name
  policy_arn = aws_iam_policy.velero.arn
}

resource "aws_iam_policy" "velero" {
  name_prefix = "velero"
  description = "policy for velero resources"
  policy      = data.aws_iam_policy_document.velero.json
}

resource "kubernetes_secret" "velero_s3_secret" {
  metadata {
    name = "velero-s3-secret"
    namespace = kubernetes_namespace.velero.id
  }
  data = {
    "AWS_ACCESS_KEY_ID" = aws_iam_access_key.velero.id
    "AWS_SECRET_ACCESS_KEY" = aws_iam_access_key.velero.secret
  }
}

resource "aws_s3_bucket" "velero" {
  bucket        = var.velero_bucket
  acl           = "private"
  force_destroy = var.force_destroy_bucket

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "velero" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.velero_bucket}",
      "arn:aws:s3:::${var.velero_bucket}/*"
    ]
  }

  statement {
    sid    = "AllowUserToSeeBucketListInTheConsole"
    effect = "Allow"
    actions = ["s3:ListAllMyBuckets", "s3:GetBucketLocation"]

    resources = [
      "arn:aws:s3:::*"
    ]
  }

}
