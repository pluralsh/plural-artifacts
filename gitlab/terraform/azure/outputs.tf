output "console_msi_client_id" {
  value = azurerm_user_assigned_identity.console.client_id
}

output "console_msi_id" {
  value = azurerm_user_assigned_identity.console.id
}

output "access_key_id" {
  value = module.minio.access_key_id
}

output "secret_access_key" {
  value = module.minio.secret_access_key
}