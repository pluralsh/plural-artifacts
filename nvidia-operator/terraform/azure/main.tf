resource "kubernetes_namespace" "nvidia-operator" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "nvidia-operator"
    }
  }
}
