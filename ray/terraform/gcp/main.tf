resource "kubernetes_namespace" "ray" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "ray"

    }
  }
}

