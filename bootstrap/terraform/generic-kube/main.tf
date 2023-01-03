resource "kubernetes_namespace" "bootstrap" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "bootstrap"

    }
  }
}
