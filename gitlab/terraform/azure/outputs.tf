output "gitlab_msi_client_id" {
  value = azurerm_user_assigned_identity.gitlab.client_id
}

output "gitlab_msi_id" {
  value = azurerm_user_assigned_identity.gitlab.id
}

output "access_key_id" {
  value = module.minio.access_key_id
}

output "secret_access_key" {
  value = module.minio.secret_access_key
}