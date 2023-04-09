resource "kubernetes_namespace" "weaviate" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "weaviate"
    }
  }
}

resource "kubernetes_service_account" "weaviate" {
  metadata {
    name      = "weaviate"
    namespace = var.namespace
  }

  depends_on = [
    kubernetes_namespace.weaviate
  ]
}
