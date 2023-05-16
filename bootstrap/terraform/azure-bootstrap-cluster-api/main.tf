data "azurerm_kubernetes_cluster" "cluster" {
  name = var.cluster_name
}