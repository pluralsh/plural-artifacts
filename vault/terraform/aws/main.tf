resource "kubernetes_namespace" "vault" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "vault"

    }
  }
}

resource "aws_kms_key" "auto_unseal_key" {
  description = "KMS key to auto-unseal Vault"
  deletion_window_in_days = 10
  tags = {
    Name = "vault-auto-unseal-key"
  }
}

resource "aws_iam_policy" "vault" {
  name = "${var.cluster_name}-vault"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:DescribeKey"
        ]
        Resource = aws_kms_key.auto_unseal_key.arn
        Effect = "Allow"
      }
    ]
  })
}

data "aws_caller_identity" "current" {
}

data "aws_eks_cluster" "plural" {
  name = var.cluster_name
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  oidc_provider = regex("^(https?://)(.*)$", data.aws_eks_cluster.plural.identity[0].oidc[0].issuer)[1]
}

module "assumable_role_vault" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "3.14.0"
  create_role = true
  role_name = "${var.cluster_name}-vault"
  role_policy_arns = [aws_iam_policy.vault.arn]
  provider_url = local.oidc_provider
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:${var.namespace}:vault"
  ]
}
