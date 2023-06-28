resource "kubernetes_namespace" "neo4j" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "neo4j"
    }
  }
}

