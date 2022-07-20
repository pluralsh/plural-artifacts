resource "kubernetes_namespace" "kyverno" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kyverno"
    }
  }
}
