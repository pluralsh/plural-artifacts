resource "kubernetes_namespace" "meilisearch" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "meilisearch"
    }
  }
}

