resource "kubernetes_namespace" "mlflow" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by"   = "plural"
      "app.plural.sh/name"             = "mlflow"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

data "azurerm_resource_group" "main" {
  name = var.resource_group
}

data "azurerm_storage_account" "main" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.main.name
}

resource "azurerm_storage_container" "mlflow" {
  name                  = var.bucket
  storage_account_name  = data.azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "kubernetes_secret" "harbor_azure_secret" {
  metadata {
    name      = "mlflow-azure-secret"
    namespace = kubernetes_namespace.harbor.id
  }
  data = {
    "AZURE_STORAGE_ACCOUNT"    = data.azurerm_storage_account.main.name
    "AZURE_STORAGE_ACCESS_KEY" = data.azurerm_storage_account.main.primary_access_key
  }
}
