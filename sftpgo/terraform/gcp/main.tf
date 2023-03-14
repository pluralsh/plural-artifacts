resource "kubernetes_namespace" "sftpgo" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "sftpgo"
    }
  }
}

module "sftpgo-workload-identity" {
  source              = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name                = "${var.cluster_name}-sftpgo-workload"
  namespace           = var.namespace
  project_id          = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa     = false
  k8s_sa_name         = "sftpgo"
  roles               = ["roles/storage.admin"] # TODO: allow to add custom roles through a tf var, default to empty list
}
