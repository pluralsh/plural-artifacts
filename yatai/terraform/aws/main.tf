resource "kubernetes_namespace" "yatai" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "yatai"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

resource "kubernetes_namespace" "yatai-system" {
  metadata {
    name = "yatai-system"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "yatai"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}



data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "s3_buckets" {
  source        = "github.com/pluralsh/module-library//terraform/s3-buckets?ref=bucket-protection"
  bucket_names  = [var.bucket]
  policy_prefix = "yatai"
  force_destroy = var.force_destroy_bucket
}

module "assumable_role_yatai" {
  source           = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version          = "3.14.0"
  create_role      = true
  role_name        = "${var.cluster_name}-${var.role_name}"
  provider_url     = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns = [module.s3_buckets.policy_arn]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${var.namespace}:${var.yatai_serviceaccount}",
    "system:serviceaccount:${var.namespace}:${var.yatai_deployment_serviceaccount}",
    "system:serviceaccount:${var.namespace}:${var.yatai_image_builder_serviceaccount}"
  ]
}

resource "aws_iam_user" "yatai" {
  name = "${var.cluster_name}-yatai"
}

resource "aws_iam_access_key" "yatai" {
  user = aws_iam_user.yatai.name
}

resource "kubernetes_secret" "s3_yatai" {
  metadata {
    name      = "yatai-aws-s3-creds"
    namespace = kubernetes_namespace.yatai.id
  }

  data = {
    "access_key" = aws_iam_access_key.yatai.id
    "secret_key" = aws_iam_access_key.yatai.secret
  }
}

resource "aws_iam_policy" "yatai" {
  name_prefix = "yatai"
  description = "policy for the plural admin yatai"
  policy      = data.aws_iam_policy_document.yatai.json
}

data "aws_iam_policy_document" "yatai" {
  statement {
    sid     = "admin"
    effect  = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.bucket}",
      "arn:aws:s3:::${var.bucket}/*",
    ]
  }
}

resource "aws_iam_policy_attachment" "yatai-user" {
  name       = "${var.cluster_name}-yatai-policy"
  users      = [aws_iam_user.yatai.name]
  policy_arn = aws_iam_policy.yatai.arn
}
