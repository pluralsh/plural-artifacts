output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the Yatai S3 buckets."
  value       = module.assumable_role_yatai.this_iam_role_arn
}

output "ecr_registry_url" {
  description = "ECR registry URL."
  value       = try(split("/", aws_ecr_repository.this[0].repository_url)[0], null)
}
