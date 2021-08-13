resource "kubernetes_namespace" "knative" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "serving.knative.dev/release" = "v0.24.0"
      "istio-injection" = "enabled"
      "app.plural.sh/name" = "knative"
    }
  }
}
