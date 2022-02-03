
output "cluster_name" {
  value = module.cluster.cluster_id
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
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

output "node_groups" {
  value = [for d in module.cluster.node_groups: d]
}
