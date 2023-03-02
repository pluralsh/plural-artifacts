data "azurerm_resource_group" "group" {
  name = var.resource_group
}

data "azurerm_subscription" "current" {}

resource "kubernetes_namespace" "gitlab" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "gitlab"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

resource "azurerm_user_assigned_identity" "gitlab" {
  resource_group_name = data.azurerm_resource_group.group.name
  location            = data.azurerm_resource_group.group.location

  name = "${var.cluster_name}-gitlab"
}

resource "azurerm_role_assignment" "rg-reader" {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Owner"
  principal_id         = azurerm_user_assigned_identity.gitlab.principal_id
}

module "minio" {
  source = "github.com/pluralsh/module-library//terraform/minio-buckets"
  minio_server = var.minio_server
  minio_region = var.minio_region
  minio_namespace = var.minio_namespace
  bucket_names = [
    var.registry_bucket,
    var.artifacts_bucket,
    var.packages_bucket,
    var.backups_bucket,
    var.backups_tmp_bucket,
    var.lfs_bucket,
    var.runner_cache_bucket,
    var.terraform_bucket
  ]
  user_name = "gitlab"
}
