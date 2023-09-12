output "cluster" {
  value = var.cluster_api ? merge(one(data.google_container_cluster.cluster[*]), {ca_certificate=one(data.google_container_cluster.cluster[*]).master_auth.0.cluster_ca_certificate}) : one(module.gke[*])
  sensitive = true
}

output "vpc_network" {
  value = one(google_compute_network.vpc_network[*])
}

output "capi_sa_workload_identity_email" {
  value = module.capi-workload-identity.gcp_service_account_email
}