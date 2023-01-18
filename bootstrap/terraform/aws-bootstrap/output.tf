
output "cluster_name" {
  value = local.cluster_id
}

output "cluster_endpoint" {
  value = local.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  value = local.cluster_oidc_issuer_url
}

output "cluster_private_subnets" {
  value = data.aws_subnet.private_subnets
}

output "cluster_worker_private_subnets" {
  value = data.aws_subnet.worker_private_subnets
}

output "cluster_public_subnets" {
  value = data.aws_subnet.public_subnets
}

output "cluster_private_subnet_ids" {
  value = local.private_subnet_ids
}

output "cluster_worker_private_subnet_ids" {
  value = local.worker_private_subnet_ids
}

output "cluster_public_subnet_ids" {
  value = local.public_subnet_ids
}

output "worker_role_arn" {
  value = module.cluster.worker_iam_role_arn
}

output "node_groups" {
  value = [for d in merge(module.single_az_node_groups.node_groups, module.multi_az_node_groups.node_groups): d]
}

output "vpc" {
  value = try(var.create_cluster ? module.vpc : tomap(false), data.aws_vpc.vpc[0])
}

output "vpc_cidr" {
  value = var.create_cluster ? module.vpc.vpc_cidr_block : data.aws_vpc.vpc[0].cidr_block
}


output "cluster" {
  value =  try(var.create_cluster ? module.cluster : tomap(false), data.aws_eks_cluster.cluster[0])
}

output "cluster_service_ipv4_cidr" {
  value = var.create_cluster ? module.cluster.cluster_service_ipv4_cidr : data.aws_eks_cluster.cluster[0].kubernetes_network_config[0].service_ipv4_cidr
}