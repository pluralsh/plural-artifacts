resource "kubernetes_namespace" "gcp-config-connector" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "gcp-config-connector"
      "cnrm.cloud.google.com/system" = "true"
    }
    annotations = {
      "cnrm.cloud.google.com/version" = "1.82.0"
    }
  }
}

resource "kubernetes_service_account" "gcp-cc" {
  metadata {
    name      = "cnrm-controller-manager"
    namespace = var.namespace
    annotations = {
      "cnrm.cloud.google.com/version" = "1.82.0"
      "iam.gke.io/gcp-service-account" = module.gcp-cc-workload-identity.gcp_service_account_email
    }
    labels = {
      "cnrm.cloud.google.com/system" = "true"
    }
  }

  depends_on = [
    kubernetes_namespace.gcp-config-connector
  ]
}

module "gcp-cc-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-gcp-config-connector"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = "cnrm-controller-manager"
  roles = ["roles/owner"]
}
