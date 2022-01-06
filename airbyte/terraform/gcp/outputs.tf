output "access_key_id" {
  value = google_storage_hmac_key.airbyte.access_id
}

output "secret_access_key" {
  value = google_storage_hmac_key.airbyte.secret
}