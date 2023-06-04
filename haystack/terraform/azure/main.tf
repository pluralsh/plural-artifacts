resource "kubernetes_namespace" "haystack" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "haystack"

    }
  }
}

