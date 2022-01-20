resource "kubernetes_namespace" "minio" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "minio"
    }
  }
}

data "kubernetes_secret" "rook" {
  metadata {
    name = "rook-ceph-object-user-ceph-objectstore-s3-admin"
    namespace = var.rook_namespace
  }
}

resource "kubernetes_secret" "minio_s3_secret" {
  metadata {
    name = "minio-s3-secret"
    namespace = kubernetes_namespace.minio.id
  }
  data = {
    "AWS_ACCESS_KEY_ID" = data.kubernetes_secret.rook.AccessKey
    "AWS_SECRET_ACCESS_KEY" = data.kubernetes_secret.rook.SecretKey
  }
}
