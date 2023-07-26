module "assumable_role_cube" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [module.s3_buckets.policy_arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.cube_serviceaccount}"]
}

resource "aws_iam_user" "cube" {
  name = "${var.cluster_name}-cube"
}

resource "aws_iam_access_key" "cube" {
  user = aws_iam_user.cube.name
}

resource "aws_iam_policy_attachment" "cube-user" {
  name = "${var.cluster_name}-cube-policy"
  users = [aws_iam_user.cube.name]
  policy_arn = module.s3_buckets.policy_arn
}
