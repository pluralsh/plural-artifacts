resource "kubernetes_namespace" "dex" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "dex"
    }
  }
}
