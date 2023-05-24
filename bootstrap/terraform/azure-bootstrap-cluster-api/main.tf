data "azurerm_kubernetes_cluster" "cluster" {
  name = var.cluster_name
  resource_group_name = var.resource_group
}
