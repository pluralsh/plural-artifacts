data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_mlflow" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.mlflow.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*:${var.mlflow_serviceaccount}"
  ]
}

resource "aws_iam_policy" "mlflow" {
  name_prefix = "mlflow"
  description = "policy for mlflow operator resources"
  policy      = data.aws_iam_policy_document.mlflow.json
}

resource "aws_s3_bucket" "pipelines" {
  bucket        = var.mlflow_bucket
  acl           = "private"
  force_destroy = true
}

data "aws_iam_policy_document" "mlflow" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.mlflow_bucket}",
      "arn:aws:s3:::${var.mlflow_bucket}/*"
    ]
  }
}
