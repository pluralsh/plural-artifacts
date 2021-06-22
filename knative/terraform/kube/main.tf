resource "kubernetes_namespace" "knative" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}