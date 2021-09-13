resource "kubernetes_namespace" "goldilocks" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "goldilocks"
    }
  }
}
