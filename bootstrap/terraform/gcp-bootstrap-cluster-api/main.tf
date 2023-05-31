data "google_container_cluster" "cluster" {
  name = var.cluster_name
  location = var.gcp_region
}

module "externaldns-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-externaldns"
  namespace           = var.namespace
  project_id          = var.gcp_project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "external-dns"
  roles               = ["roles/dns.admin"]

  depends_on = [data.google_container_cluster.cluster]
}

resource "kubernetes_service_account_v1" "externaldns" {
  metadata {
    name      = "external-dns"
    namespace = var.namespace

    annotations = {
      "iam.gke.io/gcp-service-account" = module.externaldns-workload-identity.gcp_service_account_email
    }
  }
}

module "certmanager-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  use_existing_k8s_sa = true
  cluster_name        = var.cluster_name
  location            = var.gcp_region
  name                = "${var.cluster_name}-certmanager"
  namespace           = var.namespace
  k8s_sa_name         = "certmanager"
  project_id          = var.gcp_project_id
  roles               = ["roles/dns.admin"]
}