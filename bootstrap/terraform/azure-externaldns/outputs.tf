output "externaldns_msi_client_id" {
  value = azurerm_user_assigned_identity.externaldns.client_id
}

output "externaldns_msi_id" {
  value = azurerm_user_assigned_identity.externaldns.id
}