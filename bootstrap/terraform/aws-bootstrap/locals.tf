locals {
  sts_principal             = "sts.${data.aws_partition.current.dns_suffix}"
  create_vpc                = var.create_cluster && var.create_vpc ? true : false
  vpc_id                    = var.create_cluster ? one(module.vpc[*].vpc_id) : one(data.aws_eks_cluster.cluster[*].vpc_config[0].vpc_id)
  cluster_id                = var.create_cluster ? one(module.cluster[*].cluster_id) : one(data.aws_eks_cluster.cluster[*].id)
  cluster_config            = var.create_cluster ? one(module.cluster[*].config_map_aws_auth) : {}
  cluster_oidc_issuer_url   = var.create_cluster ? one(module.cluster[*].cluster_oidc_issuer_url) : one(data.aws_eks_cluster.cluster[*].identity[0].oidc.0.issuer)
  cluster_endpoint          = var.create_cluster ? one(module.cluster[*].cluster_endpoint) : one(data.aws_eks_cluster.cluster[*].endpoint)
}

locals {
  private_subnet_ids        = var.create_cluster ? one(module.vpc[*].private_subnets_ids) : [for index, subnet in data.aws_subnet.cluster_subnets : subnet.id if contains(keys(subnet.tags), "kubernetes.io/role/internal-elb")]
  private_subnet            = var.create_cluster ? one(module.vpc[*].private_subnets_ids) : [for index, subnet in data.aws_subnet.cluster_subnets : subnet if contains(keys(subnet.tags), "kubernetes.io/role/internal-elb")]
  public_subnet_ids         = var.create_cluster ? one(module.vpc[*].public_subnets_ids) : [for index, subnet in data.aws_subnet.cluster_subnets : subnet.id if contains(keys(subnet.tags), "kubernetes.io/role/elb")]
  public_subnet             = var.create_cluster ? one(module.vpc[*].public_subnets_ids) : [for index, subnet in data.aws_subnet.cluster_subnets : subnet if contains(keys(subnet.tags), "kubernetes.io/role/elb")]
  worker_private_subnet_ids = var.create_cluster ? one(module.vpc[*].worker_private_subnets_ids) : distinct(flatten([for index, group in data.aws_eks_node_group.cluster : group.subnet_ids ]))
}
