resource "kubernetes_namespace" "mimir" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "mimir"

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

resource "azurerm_storage_container" "blocks_bucket" {
  name                  = var.mimir_blocks_bucket
  storage_account_name  = data.azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "alert_bucket" {
  name                  = var.mimir_alert_bucket
  storage_account_name  = data.azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "ruler_bucket" {
  name                  = var.mimir_ruler_bucket
  storage_account_name  = data.azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "kubernetes_secret" "mimir_azure_secret" {
  metadata {
    name = "mimir-azure-secret"
    namespace = kubernetes_namespace.mimir.id
  }
  data = {
    "AZURE_STORAGE_ACCOUNT" = data.azurerm_storage_account.main.name
    "AZURE_STORAGE_KEY" = data.azurerm_storage_account.main.primary_access_key
  }
}
