module "assumable_role_ack_iam_controller" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.ack_iam_role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.ack_iam_controller.arn]
  oidc_subjects_with_wildcards = ["system:serviceaccount:${var.namespace}:${var.ack_iam_sa_name}"]
}

resource "aws_iam_policy" "ack_iam_controller" {
  name_prefix = "ack_iam_controller"
  description = "policy for ack iam controller"
  policy      = data.aws_iam_policy_document.ack_iam_controller.json
}

data "aws_iam_policy_document" "ack_iam_controller" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = [
        "iam:GetRole",
        "iam:CreateRole",
        "iam:DeleteRole",
        "iam:UpdateRole",
        "iam:GetPolicy",
        "iam:CreatePolicy",
        "iam:DeletePolicy",
        "iam:ListAttachedRolePolicies",
        "iam:AttachRolePolicy",
        "iam:DetachRolePolicy",
        "iam:ListRoleTags",
        "iam:TagRole",
        "iam:UntagRole"
    ]
    resources = ["*"]
  }
}
