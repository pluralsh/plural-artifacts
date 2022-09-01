resource "kubernetes_namespace" "filecoin" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "filecoin"
    }
  }
}
