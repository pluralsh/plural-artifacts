resource "kubernetes_namespace" "mlflow" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "mlflow"
    }
  }
}
