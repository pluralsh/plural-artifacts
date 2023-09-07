data "aws_eks_cluster" "cluster" {
  count = var.create_cluster ? 0 : 1
  name  = var.cluster_name
}

data "aws_vpc" "vpc" {
  count = var.create_cluster ? 0 : 1
  id    = local.vpc_id
}

data "aws_eks_node_groups" "cluster" {
  count        = var.create_cluster ? 0 : 1
  cluster_name = var.cluster_name
}

data "aws_eks_node_group" "cluster" {
  count           = var.create_cluster ? 0 : length(one(data.aws_eks_node_groups.cluster[*].names))
  cluster_name    = var.cluster_name
  node_group_name = tolist(one(data.aws_eks_node_groups.cluster[*].names))[count.index]
}

data "aws_subnet" "cluster_subnets" {
  count = var.create_cluster ? 0 : length(one(data.aws_eks_cluster.test_cluster[*].vpc_config[0].subnet_ids))
  id    = tolist(one(data.aws_eks_cluster.test_cluster[*].vpc_config[0].subnet_ids))[count.index]
}


data "aws_subnet" "worker_private_subnets" {
    count = length(local.worker_private_subnet_ids)
    id       = local.worker_private_subnet_ids[count.index]
}
