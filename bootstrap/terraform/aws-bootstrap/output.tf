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
  value = var.create_cluster ? one(module.cluster[*].worker_iam_role_arn) : data.aws_eks_node_group.cluster[0].node_role_arn
}

output "node_groups" {
  value = var.create_cluster ? [for d in merge(one(module.single_az_node_groups[*].node_groups), one(module.multi_az_node_groups[*].node_groups)): d] : data.aws_eks_node_group.cluster[*]
}

output "vpc" {
  value = try(var.create_cluster ? one(module.vpc[*]) : tomap(false), one(data.aws_vpc.vpc[*]))
}

output "vpc_cidr" {
  value = var.create_cluster ? one(module.vpc[*].vpc_cidr_block) : one(data.aws_vpc.vpc[*].cidr_block)
}


output "cluster" {
  value =  try(var.create_cluster ? one(module.cluster[*]) : tomap(false), one(data.aws_eks_cluster.cluster[*]))
}

output "cluster_service_ipv4_cidr" {
  value = var.create_cluster ? one(module.cluster[*].cluster_service_ipv4_cidr) : one(data.aws_eks_cluster.cluster[*].kubernetes_network_config[0].service_ipv4_cidr)
}

output "capa_iam_role_arn" {
  description = "ARN of IAM role that allows access to the Harbor S3 buckets."
  value       = module.asummable_role_capa.this_iam_role_arn
}
