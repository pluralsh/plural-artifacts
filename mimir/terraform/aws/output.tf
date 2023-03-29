output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the Mimir S3 buckets."
  value       = module.iam_assumable_role_admin.iam_role_arn
}
