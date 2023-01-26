resource "kubernetes_namespace" "monitoring" {
  count = var.create ? 1 : 0
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "monitoring"
      "istio-injection" = "disabled"
    }
  }
}
