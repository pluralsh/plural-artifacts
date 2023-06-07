output "access_key_id" {
  value = google_storage_hmac_key.this.access_id
}

output "secret_access_key" {
  value = google_storage_hmac_key.this.secret
}

output "credentials_json" {
  value = google_service_account_key.this.private_key
}

output "service_account_email" {
  #value = google_service_account.this.email
  value = module.yatai_workload_identity.gcp_service_account_email
}
