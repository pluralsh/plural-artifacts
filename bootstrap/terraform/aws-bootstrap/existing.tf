data "aws_eks_cluster" "cluster" {
    count = var.create_cluster ? 0 : 1
    name = var.cluster_name
}

data "aws_vpc" "vpc" {
    count = var.create_cluster ? 0 : 1
    id = local.vpc_id
}

data "aws_subnet" "worker_private_subnets" {
    for_each = toset(var.worker_private_subnet_ids)
    id       = each.value
}

data "aws_subnet" "private_subnets" {
    for_each = toset(var.private_subnet_ids)
    id       = each.value
}
  
data "aws_subnet" "public_subnets" {
    for_each = toset(var.public_subnet_ids)
    id       = each.value
}
