module "assumable_role_airflow" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [module.s3_buckets.policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.dagster_serviceaccount}"]
}

resource "aws_iam_user" "dagster" {
  name = "${var.cluster_name}-dagster"
}

resource "aws_iam_access_key" "dagster" {
  user = aws_iam_user.dagster.name
}

resource "aws_iam_policy_attachment" "dagster-user" {
  name = "${var.cluster_name}-dagster-policy"
  users = [aws_iam_user.dagster.name]
  policy_arn = module.s3_buckets.policy_arn
}

resource "kubernetes_secret" "dagster_s3_secret" {
  metadata {
    name = "dagster-aws-env"
    namespace = kubernetes_namespace.dagster.id
  }

  data = {
    "AWS_ACCESS_KEY_ID" = aws_iam_access_key.dagster.id
    "AWS_SECRET_ACCESS_KEY" = aws_iam_access_key.dagster.secret
  }
}