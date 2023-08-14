output "access_key_id" {
  value = google_storage_hmac_key.airbyte.access_id
}

output "secret_access_key" {
  value = google_storage_hmac_key.airbyte.secret
}

output "credentials_json" {
  value = google_service_account_key.airbyte_key.private_key
}

output "gcp_sa_email" {
  value = google_service_account.airbyte.email
}