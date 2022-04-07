resource "kubernetes_namespace" "kubeflow" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kubeflow"
      "istio-injection" = "enabled"
    }
  }
}
