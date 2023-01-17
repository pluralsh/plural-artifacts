locals {
    sts_principal = "sts.${data.aws_partition.current.dns_suffix}"

    private_subnet_ids = var.create_cluster ? module.vpc.private_subnets_ids : var.private_subnet_ids

    public_subnet_ids = var.create_cluster ? module.vpc.public_subnets_ids : var.public_subnet_ids

    worker_subnet_ids = var.create_cluster ? module.vpc.worker_private_subnets_ids : var.worker_private_subnet_ids
    worker_private_subnets = var.create_cluster ? module.vpc.worker_private_subnets : data.aws_subnet.worker_private_subnets[*]

    vpc_id = var.create_cluster ? module.vpc.vpc_id : data.aws_eks_cluster.cluster[0].vpc_config[0].vpc_id
    
    cluster_id = var.create_cluster ? module.cluster.cluster_id : data.aws_eks_cluster.cluster[0].id
    cluster_config = try(var.create_cluster ? module.cluster.config_map_aws_auth : tomap(false), {})
    node_groups = var.create_cluster ? [module.single_az_node_groups.node_groups, module.multi_az_node_groups.node_groups] : []
    cluster_oidc_issuer_url = var.create_cluster ? module.cluster.cluster_oidc_issuer_url : data.aws_eks_cluster.cluster[0].identity[0].oidc.0.issuer
}