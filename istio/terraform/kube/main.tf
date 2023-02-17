resource "kubernetes_namespace" "istio-operator" {
  count = var.operator_namespace == var.istio_namespace ? 0 : 1
  metadata {
    name = var.operator_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "istio"
    }
  }
}

resource "kubernetes_namespace" "istio-system" {
  metadata {
    name = var.istio_namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "istio"
      "istio-operator-managed" = "Reconcile"
      "istio-injection" = "disabled"
      "istio" = "system"
    }
  }
}
