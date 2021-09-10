resource "kubernetes_namespace" "postgres" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "postgres"
    }
  }
}
