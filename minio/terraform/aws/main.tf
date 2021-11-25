resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "minio"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_minio" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.16.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.minio.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*:${var.minio_serviceaccount}"
  ]
}

resource "aws_iam_access_key" "minio" {
  user    = aws_iam_user.minio.name
}

# create iam user(s) with full s3 permissions
resource "aws_iam_user" "minio" {
  name          = "minio"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "attach_s3_full_access" {
  user       = aws_iam_user.minio.name
  policy_arn = aws_iam_policy.minio.arn
}

resource "aws_iam_policy" "minio" {
  name_prefix = "minio"
  description = "policy for minio resources"
  policy      = data.aws_iam_policy_document.minio.json
}

resource "kubernetes_secret" "minio_s3_secret" {
  metadata {
    name = "minio-s3-secret"
    namespace = kubernetes_namespace.minio.id
  }
  data = {
    "AWS_ACCESS_KEY_ID" = aws_iam_access_key.minio.id
    "AWS_SECRET_ACCESS_KEY" = aws_iam_access_key.minio.secret
  }
}

resource "aws_s3_bucket" "minio" {
  bucket = var.minio_bucket
  acl    = "private"
}

data "aws_iam_policy_document" "minio" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.minio_bucket}",
      "arn:aws:s3:::${var.minio_bucket}/*"
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
