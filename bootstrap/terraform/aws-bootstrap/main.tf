data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

module "vpc" {
  source                 = "github.com/pluralsh/terraform-aws-vpc?ref=worker_subnet"
  name                   = var.vpc_name
  cidr                   = "10.0.0.0/16"
  azs                    = data.aws_availability_zones.available.names
  public_subnets         = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  private_subnets        = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  worker_private_subnets = ["10.0.16.0/20", "10.0.32.0/20", "10.0.48.0/20"]
  enable_dns_hostnames   = true
  enable_ipv6            = true

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
  source          = "github.com/pluralsh/terraform-aws-eks?ref=always-create-auth-cm"
  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  private_subnets = module.vpc.private_subnets_ids
  public_subnets  = module.vpc.public_subnets_ids
  worker_private_subnets = module.vpc.worker_private_subnets
  vpc_id          = module.vpc.vpc_id
  enable_irsa     = true
  write_kubeconfig = false

  node_groups_defaults = {}

  node_groups = {}

  map_users = var.map_users
  map_roles = concat(var.map_roles, var.manual_roles)
}

module "single_az_node_groups" {
  source                 = "github.com/pluralsh/module-library//terraform/eks-node-groups/single-az-node-groups?ref=7b6d3b1d1602e4265d6d3b172c38fe67d9a2c7fc"
  cluster_name           = var.cluster_name
  default_iam_role_arn   = module.cluster.worker_iam_role_arn
  tags                   = {}
  node_groups_defaults   = var.node_groups_defaults

  node_groups            = var.single_az_node_groups
  set_desired_size       = false
  private_subnets        = module.vpc.worker_private_subnets

  ng_depends_on = [
    module.cluster.config_map_aws_auth
  ]
}

module "multi_az_node_groups" {
  source                 = "github.com/pluralsh/module-library//terraform/eks-node-groups/multi-az-node-groups?ref=aws-multi-az"
  cluster_name           = var.cluster_name
  default_iam_role_arn   = module.cluster.worker_iam_role_arn
  tags                   = {}
  node_groups_defaults   = var.node_groups_defaults

  node_groups            = var.multi_az_node_groups
  set_desired_size       = false
  private_subnet_ids     = module.vpc.worker_private_subnets_ids

  ng_depends_on = [
    module.cluster.config_map_aws_auth
  ]
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name = module.cluster.cluster_id
  addon_name   = "vpc-cni"
  addon_version     = "v1.10.1-eksbuild.1"
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
  cluster_name      = module.cluster.cluster_id
  addon_name        = "coredns"
  addon_version     = "v1.8.4-eksbuild.1"
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
  cluster_name      = module.cluster.cluster_id
  addon_name        = "kube-proxy"
  addon_version     = "v1.21.2-eksbuild.2"
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
  metadata {
    name = "bootstrap"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "bootstrap"
    }
  }

  depends_on = [
    module.cluster.cluster_id
  ]
}
