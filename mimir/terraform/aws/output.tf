output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the Mimir S3 buckets."
  value       = module.assumable_role_mimir.iam_role_arn
}
