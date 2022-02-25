
output "cluster" {
  value = module.gke
  sensitive = true
}

output "vpc_network" {
  value = google_compute_network.vpc_network
}