output "google_kms_key_ring_location" {
  value = google_kms_key_ring.vault.location
}

output "google_kms_key_ring_name" {
  value = google_kms_key_ring.vault.name
}

output "google_kms_crypto_key_name" {
  value = google_kms_crypto_key.vault.name
}
