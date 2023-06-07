output "access_key_id" {
  value = minio_iam_user.user.id
}

output "secret_access_key" {
  value = minio_iam_user.user.secret
}
