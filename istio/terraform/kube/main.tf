resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}