resource "kubernetes_namespace" "jitsu" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "jitsu"

    }
  }
}

