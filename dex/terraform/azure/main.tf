resource "kubernetes_namespace" "console" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}
