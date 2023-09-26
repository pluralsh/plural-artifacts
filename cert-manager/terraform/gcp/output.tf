output "service_account_email" {
  value = module.cert_manager_workload_identity.gcp_service_account_email
}
