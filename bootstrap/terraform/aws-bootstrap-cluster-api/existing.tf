data "aws_eks_cluster" "cluster" {
    count = var.create_cluster ? 0 : 1
    name = var.cluster_name
}

data "aws_vpc" "vpc" {
    count = var.create_cluster ? 0 : 1
    id = local.vpc_id
}

data "aws_subnet" "worker_private_subnets" {
    count = length(local.worker_private_subnet_ids)
    id       = local.worker_private_subnet_ids[count.index]
}

data "aws_subnet" "private_subnets" {
    count = length(local.private_subnet_ids)
    id       = local.private_subnet_ids[count.index]
}
  
data "aws_subnet" "public_subnets" {
    count = length(local.public_subnet_ids)
    id       = local.public_subnet_ids[count.index]
}
