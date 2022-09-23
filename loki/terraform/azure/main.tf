resource "kubernetes_namespace" "loki" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "loki"

    }
  }
}

data "azurerm_resource_group" "main" {
  name = var.resource_group
}

data "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.main.name
}

resource "azurerm_storage_container" "loki" {
  name                  = var.loki_container
  storage_account_name  = data.azurerm_storage_account.main.name
  container_access_type = "private"
}

# resource "azurerm_user_assigned_identity" "loki" {
#   resource_group_name = data.azurerm_resource_group.group.name
#   location            = data.azurerm_resource_group.group.location

#   name = "${var.cluster_name}-loki"
# }

# resource "azurerm_role_assignment" "data-contributor-role" {
#   scope                = azurerm_storage_container.loki.resource_manager_id
#   role_definition_name = "Storage Blob Data Contributor"
#   principal_id         = azurerm_user_assigned_identity.loki.principal_id
# }

resource "kubernetes_secret" "loki_azure_secret" {
  metadata {
    name = "loki-azure-secret"
    namespace = kubernetes_namespace.loki.id
  }
  data = {
    "AZURE_STORAGE_ACCOUNT" = data.azurerm_storage_account.main.name
    "AZURE_STORAGE_KEY" = data.azurerm_storage_account.main.primary_access_key
  }
}
