output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the MySQL backup S3 buckets."
  value       = module.assumable_role_mysql.this_iam_role_arn
}
