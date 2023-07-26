output "iam_access_key_id" {
  description = "Access key ID of IAM user that allows access to the cube S3 bucket."
  value       = aws_iam_access_key.cube.id
}

output "iam_access_key_secret" {
  description = "Secret access key of IAM user that allows access to the cube S3 bucket."
  value       = aws_iam_access_key.cube.secret
}