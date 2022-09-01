output "access_key_id" {
  value = google_storage_hmac_key.kubeflow.access_id
}

output "secret_access_key" {
  value = google_storage_hmac_key.kubeflow.secret
}
