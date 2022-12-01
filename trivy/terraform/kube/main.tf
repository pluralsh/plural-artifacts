resource "kubernetes_namespace" "trivy" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "trivy"

    }
  }
}

