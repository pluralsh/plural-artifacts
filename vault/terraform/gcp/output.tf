output "google_kms_key_ring_location" {
  value = google_kms_key_ring.vault.location
}

output "google_kms_key_ring_id" {
  value = google_kms_key_ring.vault.id
}

output "google_kms_crypto_key_id" {
  value = google_kms_crypto_key.vault.id
}
