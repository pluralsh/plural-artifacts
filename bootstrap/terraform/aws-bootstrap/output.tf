
output "cluster_name" {
  value = module.cluster.cluster_id
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "cluster_private_subnets" {
  value = module.vpc.private_subnets
}

output "cluster_public_subnets" {
  value = module.vpc.public_subnets
}

output "cluster_private_subnet_ids" {
  value = data.aws_subnet_ids.cluster_private_subnets.ids
}

output "cluster_public_subnet_ids" {
  value = data.aws_subnet_ids.cluster_public_subnets.ids
}
