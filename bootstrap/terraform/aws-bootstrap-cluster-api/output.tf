output "capa_iam_role_arn" {
  description = "ARN of IAM role that allows access to the Harbor S3 buckets."
  value       = module.asummable_role_capa.this_iam_role_arn
}
