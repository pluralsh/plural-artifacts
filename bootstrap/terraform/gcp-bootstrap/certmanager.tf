module "certmanager-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-externaldns"
  namespace           = var.namespace
  project_id          = var.gcp_project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "certmanager"
  roles               = ["roles/dns.admin"]

  depends_on = [
    kubernetes_service_account.certmanager
  ]
}

resource "kubernetes_service_account" "certmanager" {
  metadata {
    name      = "certmanager"
    namespace = var.namespace

    annotations = {
      "iam.gke.io/gcp-service-account" = module.certmanager-workload-identity.gcp_service_account_email
    }
  }
}