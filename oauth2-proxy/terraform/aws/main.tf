resource "kubernetes_namespace" "oauth2proxy" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "istio-injection" = "enabled"
    }
  }
}

# resource "aws_cognito_user_pool" "pool" {
#   name = "${var.cognito_user_pool_name}"
# }

# resource "aws_cognito_user_pool_client" "client" {
#   name = "${var.cognito_user_pool_name}"
#   user_pool_id = aws_cognito_user_pool.pool.id
#   callback_urls = ["https://${var.callback_domain}/oauth2/callback"]
#   allowed_oauth_flows = ["code"]
#   allowed_oauth_scopes = ["phone", "email", "openid", "profile"]

# }

# resource "aws_route53_record" "auth-cognito-A" {
#   name    = aws_cognito_user_pool_domain.main.domain
#   type    = "A"
#   zone_id = data.aws_route53_zone.kubeflow_aws.zone_id
#   alias {
#     evaluate_target_health = false
#     name                   = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
#     # This zone_id is fixed
#     zone_id = "Z2FDTNDATAQYW2"
#   }
# }

# resource "aws_cognito_user_pool_domain" "main" {
#   domain          = "${var.cognito_user_pool_domain}"
#   certificate_arn = aws_acm_certificate.cert.arn
#   user_pool_id    = aws_cognito_user_pool.pool.id
# }

# data "aws_route53_zone" "kubeflow_aws" {
#   name = "kubeflow-aws.com"
# }

# resource "aws_acm_certificate" "cert" {
#   domain_name       = "${var.cognito_user_pool_domain}"
#   validation_method = "DNS"

#   tags = {
#     Environment = "prod"
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }
