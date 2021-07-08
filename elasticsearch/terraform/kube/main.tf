resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "istio-injection" = "enabled"
    }
  }
}
