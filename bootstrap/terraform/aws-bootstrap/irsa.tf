resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count           = var.enable_irsa && !var.create_cluster ? 1 : 0
  client_id_list  = [local.sts_principal]
  thumbprint_list = [var.eks_oidc_root_ca_thumbprint]
  url             = local.cluster_oidc_issuer_url
}
