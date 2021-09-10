resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "minio"
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

resource "kubernetes_secret" "minio_azure_secret" {
  metadata {
    name = "minio-azure-secret"
    namespace = kubernetes_namespace.minio.id
  }
  data = {
    "AZURE_STORAGE_ACCOUNT" = data.azurerm_storage_account.main.name
    "AZURE_STORAGE_KEY" = data.azurerm_storage_account.main.primary_access_key
  }
}
