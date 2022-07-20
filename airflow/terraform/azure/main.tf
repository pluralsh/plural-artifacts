data "azurerm_resource_group" "group" {
  name = var.resource_group
}

data "azurerm_subscription" "current" {}

resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "airflow"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

resource "azurerm_user_assigned_identity" "airflow" {
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location

  name = "${var.cluster_name}-airflow"
}

resource "azurerm_role_assignment" "rg-reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.airflow.principal_id
}

module "minio_buckets" {
  source = "github.com/pluralsh/module-library//terraform/minio-buckets"

  minio_server    = var.minio_server
  minio_region    = var.minio_region
  minio_namespace = var.minio_namespace
  bucket_names    = [var.airflow_bucket]
  user_name       = "airflow"
}
