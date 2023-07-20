data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  count =  var.create_cluster ? 1:0

  source                 = "github.com/pluralsh/terraform-aws-vpc?ref=worker_subnet"
  name                   = var.vpc_name
  cidr                   = var.vpc_cidr
  azs                    = data.aws_availability_zones.available.names
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  worker_private_subnets = var.worker_private_subnets
  enable_dns_hostnames   = true
  enable_ipv6            = true
  create_vpc             = local.create_vpc

  database_subnets = var.database_subnets

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }

  worker_private_subnet_tags = {
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "cluster" {
  count =  var.create_cluster ? 1:0

  source                        = "github.com/pluralsh/terraform-aws-eks?ref=output-service-cidr"
  cluster_name                  = var.cluster_name
  cluster_version               = var.kubernetes_version
  private_subnets               = local.private_subnet_ids
  public_subnets                = local.public_subnet_ids
  worker_private_subnets        = local.worker_private_subnet_ids
  vpc_id                        = local.vpc_id
  enable_irsa                   = true
  write_kubeconfig              = false
  create_eks                    = var.create_cluster
  cluster_enabled_log_types     = var.cluster_enabled_log_types
  cluster_log_retention_in_days = var.cluster_log_retention_in_days
  cluster_log_kms_key_id        = var.cluster_log_kms_key_id

  node_groups_defaults = {}

  node_groups = {}

  map_users = var.map_users
  map_roles = concat(var.map_roles, var.manual_roles)
}

module "single_az_node_groups" {
  count =  var.create_cluster ? 1:0

  source                 = "github.com/pluralsh/module-library//terraform/eks-node-groups/single-az-node-groups?ref=20e64863ffc5e361045db8e6b81b9d244a55809e"
  cluster_name           = var.cluster_name
  default_iam_role_arn   = module.cluster[0].worker_iam_role_arn
  tags                   = {}
  node_groups_defaults   = var.node_groups_defaults

  node_groups            = try(var.create_cluster ? var.single_az_node_groups : tomap(false), {})
  set_desired_size       = false
  private_subnets        = var.create_cluster ? module.vpc[0].worker_private_subnets : []

  ng_depends_on = [
    local.cluster_config
  ]
}

module "multi_az_node_groups" {
  count =  var.create_cluster ? 1:0

  source                 = "github.com/pluralsh/module-library//terraform/eks-node-groups/multi-az-node-groups?ref=20e64863ffc5e361045db8e6b81b9d244a55809e"
  cluster_name           = var.cluster_name
  default_iam_role_arn   = one(module.cluster[*].worker_iam_role_arn)
  tags                   = {}
  node_groups_defaults   = var.node_groups_defaults

  node_groups            =  try(var.create_cluster ? var.multi_az_node_groups : tomap(false), {})
  set_desired_size       = false
  private_subnet_ids     = local.worker_private_subnet_ids

  ng_depends_on = [
    local.cluster_config
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  count = var.create_cluster ? 1 : 0
  cluster_name = local.cluster_id
  addon_name   = "vpc-cni"
  addon_version     = var.vpc_cni_addon_version
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "vpc-cni"
  }
  depends_on = [
    module.single_az_node_groups.node_groups,
    module.multi_az_node_groups.node_groups,
  ]
}

resource "aws_eks_addon" "core_dns" {
  count = var.create_cluster ? 1 : 0
  cluster_name      = local.cluster_id
  addon_name        = "coredns"
  addon_version     = var.core_dns_addon_version
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "coredns"
  }
  depends_on = [
    module.single_az_node_groups.node_groups,
    module.multi_az_node_groups.node_groups,
  ]
}

resource "aws_eks_addon" "kube_proxy" {
  count = var.create_cluster ? 1 : 0
  cluster_name      = local.cluster_id
  addon_name        = "kube-proxy"
  addon_version     = var.kube_proxy_addon_version
  resolve_conflicts = "OVERWRITE"
  tags = {
      "eks_addon" = "kube-proxy"
  }
  depends_on = [
    module.single_az_node_groups.node_groups,
    module.multi_az_node_groups.node_groups,
  ]
}

resource "kubernetes_namespace" "bootstrap" {
  count =  var.create_cluster ? 1:0

  metadata {
    name = "bootstrap"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "bootstrap"
    }
  }

  depends_on = [ local.cluster_id ]
}
