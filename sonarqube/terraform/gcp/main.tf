resource "kubernetes_namespace" "sonarqube" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by"   = "plural"
      "app.plural.sh/name"             = "sonarqube"
      "platform.plural.sh/sync-target" = "pg"
    }
  }
}

