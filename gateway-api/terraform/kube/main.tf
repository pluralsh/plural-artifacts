resource "kubernetes_namespace" "gateway-api" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "gateway-api"

    }
  }
}
