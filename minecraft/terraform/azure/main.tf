resource "kubernetes_namespace" "minecraft" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "minecraft"

    }
  }
}

