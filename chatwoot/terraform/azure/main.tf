resource "kubernetes_namespace" "chatwoot" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "chatwoot"
    }
  }
}

data "azurerm_resource_group" "group" {
  name = var.resource_group
}

data "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.group.name
}

resource "azurerm_storage_container" "chatwoot" {
  name                  = var.chatwoot_container
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_user_assigned_identity" "chatwoot" {
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location

  name = "${var.cluster_name}-chatwoot"
}

resource "azurerm_role_assignment" "data-contributor-role" {
  scope                = azurerm_storage_container.chatwoot.resource_manager_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.chatwoot.principal_id
}
