resource "kubernetes_namespace" "posthog" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "posthog"

    }
  }
}

module "s3_buckets" {
  source = "github.com/pluralsh/module-library//terraform/s3-buckets"
  bucket_names = [var.posthog_bucket]
  policy_prefix = "posthog"
}

resource "aws_iam_policy" "posthog" {
  name_prefix = "posthog"
  description = "policy for the plural admin posthog"
  policy      = data.aws_iam_policy_document.posthog.json
}

resource "aws_iam_user" "posthog" {
  name = "${var.cluster_name}-posthog"
}

resource "aws_iam_access_key" "posthog" {
  user = aws_iam_user.posthog.name
}

data "aws_iam_policy_document" "posthog" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.posthog_bucket}",
      "arn:aws:s3:::${var.posthog_bucket}/*",
    ]
  }
}

resource "aws_iam_policy_attachment" "posthog-user" {
  name = "${var.cluster_name}-posthog-policy"
  users = [aws_iam_user.posthog.name]
  policy_arn = aws_iam_policy.posthog.arn
}

resource "kubernetes_secret" "s3_posthog" {
  metadata {
    name = "posthog-aws-s3-creds"
    namespace = kubernetes_namespace.posthog.id
  }

  data = {
    "root-user" = aws_iam_access_key.posthog.id
    "root-password" = aws_iam_access_key.posthog.secret
  }
}
