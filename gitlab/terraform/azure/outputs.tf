output "console_msi_client_id" {
  value = azurerm_user_assigned_identity.console.client_id
}

output "console_msi_id" {
  value = azurerm_user_assigned_identity.console.id
}
