
output "cluster" {
  value = module.gke
  sensitive = true
}

output "vpc_network" {
  value = one(google_compute_network.vpc_network[*])
}