output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the Yatai S3 buckets."
  value       = module.assumable_role_yatai.this_iam_role_arn
}
