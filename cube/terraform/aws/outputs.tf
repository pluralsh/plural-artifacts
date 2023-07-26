output "iam_role_arn" {
  description = "ARN of IAM role that allows access to the cube S3 bucket."
  value       = module.assumable_role_cube.this_iam_role_arn
}
