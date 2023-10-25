resource "kubernetes_namespace" "kas" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kas"
    }
  }
}

