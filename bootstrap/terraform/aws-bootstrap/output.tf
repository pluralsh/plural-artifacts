
output "cluster_name" {
  value = module.cluster.cluster_id
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "cluster_oidc_issuer_url" {
  value = module.cluster.cluster_oidc_issuer_url
}

output "cluster_private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_worker_private_subnets" {
  value = module.vpc.worker_private_subnets
}

output "cluster_public_subnets" {
  value = module.vpc.public_subnets
}

output "cluster_private_subnet_ids" {
  value = module.vpc.private_subnets_ids
}

output "cluster_worker_private_subnet_ids" {
  value = module.vpc.worker_private_subnets_ids
}

output "cluster_public_subnet_ids" {
  value = module.vpc.public_subnets_ids
}

output "worker_role_arn" {
  value = module.cluster.worker_iam_role_arn
}

output "node_groups" {
  value = [for d in merge(module.single_az_node_groups.node_groups, module.multi_az_node_groups.node_groups): d]
}
