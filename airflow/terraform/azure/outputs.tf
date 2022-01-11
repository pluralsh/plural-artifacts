output "airflow_msi_client_id" {
  value = azurerm_user_assigned_identity.airflow.client_id
}

output "airflow_msi_id" {
  value = azurerm_user_assigned_identity.airflow.id
}

output "access_key_id" {
  value = module.minio_buckets.access_key_id
}

output "secret_access_key" {
  value = module.minio_buckets.secret_access_key
}