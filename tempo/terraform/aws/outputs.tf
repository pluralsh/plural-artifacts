output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the Tempo S3 buckets."
  value       = module.assumable_role_tempo.this_iam_role_arn
}
