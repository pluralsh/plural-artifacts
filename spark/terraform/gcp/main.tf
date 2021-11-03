resource "kubernetes_namespace" "spark" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "spark"
    }
  }
}
