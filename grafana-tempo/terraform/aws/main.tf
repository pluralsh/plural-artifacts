resource "kubernetes_namespace" "grafana-tempo" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "grafana-tempo"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_tempo" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.tempo.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.tempo_serviceaccount}"]
}

resource "aws_iam_policy" "tempo" {
  name_prefix = "tempo"
  description = "policy for the plural admin tempo"
  policy      = data.aws_iam_policy_document.tempo.json
}

resource "aws_s3_bucket" "tempo" {
  bucket         = var.tempo_bucket
  acl            = "private"
  force_destroy  = true
}

data "aws_iam_policy_document" "tempo" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.tempo_bucket}",
      "arn:aws:s3:::${var.tempo_bucket}/*",
    ]
  }
}
