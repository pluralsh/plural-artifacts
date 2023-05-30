resource "kubernetes_namespace" "mysql" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "mysql"
    }
  }
}

module "mysql-workload-identity" {
  source     = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  name       = "${var.cluster_name}-mysql"
  namespace  = var.namespace
  project_id = var.project_id
  use_existing_k8s_sa = true
  annotate_k8s_sa = false
  k8s_sa_name = var.mysql_serviceaccount
  roles = []
  depends_on = [
    kubernetes_namespace.mysql
  ]
}

module "gcs_buckets" {
  source = "github.com/pluralsh/module-library//terraform/gcs-buckets"
  bucket_names = [var.backup_bucket]
  service_account_email = module.mysql-workload-identity.gcp_service_account_email
  project_id = var.project_id
  location = var.bucket_location
}

# resource "google_service_account_key" "mysql_key" {
#   service_account_id = module.mysql-workload-identity.gcp_service_account_name
# }

# resource "kubernetes_secret" "google-application-credentials" {
#   metadata {
#     name = "mysql-gcp-creds"
#     namespace = var.namespace
#     labels = {
#       "platform.plural.sh/sync" = "mysql"
#     }
#   }

#   data = {
#     "credentials.json" = base64decode(google_service_account_key.mysql_key.private_key)
#   }

#   depends_on = [
#     kubernetes_namespace.mysql
#   ]
# }
