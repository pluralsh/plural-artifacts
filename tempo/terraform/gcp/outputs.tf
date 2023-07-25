output "service_account_email" {
  description = "service account email that has access to the Tempo GCS buckets."
  value       = module.tempo-workload-identity.gcp_service_account_email
}
