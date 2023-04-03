resource "kubernetes_namespace" "jenkins" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "jenkins"

    }
  }
}

