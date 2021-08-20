resource "kubernetes_namespace" "ghost" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}
