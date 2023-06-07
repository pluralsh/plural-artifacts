output "gcp_sa_name" {
  description = "Name of the GCP service account that has access to the MySQL backup GCS bucket."
  value       = module.mysql-workload-identity.gcp_service_account_name
}

output "service_account_email" {
  description = "service account email that has access to the MySQL backup GCS buckets."
  value       = module.mysql-workload-identity.gcp_service_account_email
}
