data "azurerm_resource_group" "group" {
  name = var.resource_group
}

data "azurerm_dns_zone" "zone" {
  name = var.dns_zone_name
  resource_group_name = data.azurerm_resource_group.group.name
}

resource "azurerm_user_assigned_identity" "externaldns" {
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location

  name = "${var.cluster_name}-externaldns"
}

resource "azurerm_role_assignment" "rg-reader" {
  scope                = data.azurerm_resource_group.group.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.externaldns.principal_id
}

resource "azurerm_role_assignment" "dns-contributor" {
  scope                = data.azurerm_dns_zone.zone.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.externaldns.principal_id
}