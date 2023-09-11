resource "kubernetes_namespace" "istio-ingress" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "istio-ingress"

    }
  }
}

