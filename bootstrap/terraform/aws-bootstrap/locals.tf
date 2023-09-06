locals {
    sts_principal             = "sts.${data.aws_partition.current.dns_suffix}"
    create_vpc                = var.create_cluster && var.create_vpc ? true : false
    private_subnet_ids        = var.create_cluster ? module.vpc[0].private_subnets_ids : var.private_subnet_ids
    public_subnet_ids         = var.create_cluster ? module.vpc[0].public_subnets_ids : var.public_subnet_ids
    worker_private_subnet_ids = var.create_cluster ? module.vpc[0].worker_private_subnets_ids : var.worker_private_subnet_ids
    vpc_id                    = var.create_cluster ? module.vpc[0].vpc_id : data.aws_eks_cluster.cluster[0].vpc_config[0].vpc_id
    cluster_id                = var.create_cluster ? module.cluster[0].cluster_id : data.aws_eks_cluster.cluster[0].id
    cluster_config            = try(var.create_cluster ? module.cluster[0].config_map_aws_auth : tomap(false), {})
    cluster_oidc_issuer_url   = var.create_cluster ? module.cluster[0].cluster_oidc_issuer_url : data.aws_eks_cluster.cluster[0].identity[0].oidc.0.issuer
    cluster_endpoint          = var.create_cluster ? module.cluster[0].cluster_endpoint : data.aws_eks_cluster.cluster[0].endpoint
}
