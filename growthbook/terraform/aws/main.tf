resource "kubernetes_namespace" "growthbook" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "growthbook"
    }
  }
}

module "s3_buckets" {
  source        = "github.com/pluralsh/module-library//terraform/s3-buckets?ref=bucket-protection"
  bucket_names  = [var.growthbook_bucket]
  policy_prefix = "growthbook"
  force_destroy = var.force_destroy_bucket
}

module "assumable_role_growthbook" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [module.s3_buckets.policy_arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:${var.namespace}:growthbook",
  ]
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}
