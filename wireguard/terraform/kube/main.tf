resource "kubernetes_namespace" "wireguard" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "wireguard"

    }
  }
}

