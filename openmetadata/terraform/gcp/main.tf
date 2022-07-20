resource "kubernetes_namespace" "openmetadata" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "openmetadata"

    }
  }
}

