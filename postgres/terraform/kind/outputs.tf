output "access_key_id" {
  value = minio_iam_user.postgres.id
}

output "secret_access_key" {
  value = minio_iam_user.postgres.secret
}
