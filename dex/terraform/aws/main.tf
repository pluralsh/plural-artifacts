resource "kubernetes_namespace" "airflow" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
    }
  }
}
