resource "kubernetes_namespace" "redis" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "redis"
    }
  }
}
