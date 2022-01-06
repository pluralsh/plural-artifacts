output "access_key_id" {
  value = minio_iam_user.airbyte.id
}

output "secret_access_key" {
  value = minio_iam_user.airbyte.secret
}