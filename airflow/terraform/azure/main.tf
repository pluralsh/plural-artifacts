data "azurerm_resource_group" "group" {
  name = var.resource_group
}

data "azurerm_subscription" "current" {}

resource "kubernetes_namespace" "console" {
  metadata {
    name = var.namespace
  }
}

resource "azurerm_user_assigned_identity" "console" {
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location

  name = "${var.cluster_name}-console"
}

resource "azurerm_role_assignment" "rg-reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.console.principal_id
}