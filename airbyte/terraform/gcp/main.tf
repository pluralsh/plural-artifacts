resource "kubernetes_namespace" "airbyte" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "airbyte"
    }
  }
}
