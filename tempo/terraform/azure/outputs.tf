output "tempo_msi_client_id" {
  value = azurerm_user_assigned_identity.tempo.client_id
}

output "tempo_msi_id" {
  value = azurerm_user_assigned_identity.tempo.id
}
