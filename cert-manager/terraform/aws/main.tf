data "aws_eks_cluster" "cluster" {
    name = var.cluster_name
}

module "assumable_role_cert_manager" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-cert-manager"
  provider_url                  = replace(data.aws_eks_cluster.cluster[0].identity[0].oidc.0.issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.cert_manager.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.serviceaccount_name}"]
}

resource "aws_iam_policy" "cert_manager" {
  name_prefix = "cert-manager"
  description = "cert-manager permissions for ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.cert_manager.json
}

data "aws_iam_policy_document" "cert_manager" {
  statement {
    actions = [
      "route53:GetChange",
    ]
    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]
    resources = [
      "arn:aws:route53:::hostedzone/*",
    ]
  }

  statement {
    actions = [
      "route53:ListHostedZonesByName",
    ]
    resources = [
      "*",
    ]
  }
}
