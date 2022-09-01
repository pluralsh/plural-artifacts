resource "kubernetes_namespace" "trino" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "trino"
    }
  }
}
