resource "kubernetes_namespace" "kubescape" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kubescape"

    }
  }
}

