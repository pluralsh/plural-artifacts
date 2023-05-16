output "service_account_email" {
  description = "service account email that has access to the Harbor GCS buckets."
  value       = module.harbor-workload-identity.gcp_service_account_email
}
