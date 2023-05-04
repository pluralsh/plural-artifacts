output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the Harbor S3 buckets."
  value       = module.assumable_role_harbor.this_iam_role_arn
}
