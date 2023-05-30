resource "kubernetes_namespace" "ghost" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "ghost"
    }
  }
}

module "ghost-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-mysql-ghost"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = var.mysql_serviceaccount
  roles = []
  depends_on = [
    kubernetes_namespace.ghost
  ]
}

resource "google_storage_bucket_iam_member" "admin-access" {
  bucket = var.backup_bucket
  role = "roles/storage.admin"
  member = "serviceAccount:${module.ghost-workload-identity.gcp_service_account_email}"
}
