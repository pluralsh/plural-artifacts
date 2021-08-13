resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "istio-injection" = "disabled"
      "app.plural.sh/name" = "monitoring"
    }
  }
}
