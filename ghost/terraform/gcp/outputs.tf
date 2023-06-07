output "service_account_email" {
  description = "service account email that has access to the MySQL backup GCS buckets."
  value       = module.ghost-workload-identity.gcp_service_account_email
}
