module "cert_manager_workload_identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-cert-manager"
  namespace           = var.namespace
  project_id          = var.gcp_project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "${var.serviceaccount_name}"
  roles               = ["roles/dns.admin"]
}
