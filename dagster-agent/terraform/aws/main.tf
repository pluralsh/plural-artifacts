resource "kubernetes_namespace" "dagster-agent" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "dagster-agent"

    }
  }
}

