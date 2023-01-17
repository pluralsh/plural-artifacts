module "assumable_role_externaldns" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-externaldns"
  provider_url                  = replace(local.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.externaldns.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.externaldns_serviceaccount}"]
}

resource "aws_iam_policy" "externaldns" {
  name_prefix = "externaldns"
  description = "externaldns policy for cluster ${local.cluster_id}"
  policy      = data.aws_iam_policy_document.externaldns.json
}

data "aws_iam_policy_document" "externaldns" {
  statement {
    sid    = "externaldnsedit"
    effect = "Allow"

    actions = [
      "route53:ChangeResourceRecordSets"
    ]

    resources = ["arn:aws:route53:::hostedzone/*"]
  }

  statement {
    sid    = "externaldnslist"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListResourceRecordSets"
    ]

    resources = ["*"]
  }
}