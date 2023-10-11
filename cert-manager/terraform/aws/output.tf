output "iam_role_arn" {
  description = "ARN of IAM role that allows cert-manager access to route53."
  value       = module.assumable_role_cert_manager.this_iam_role_arn
}
