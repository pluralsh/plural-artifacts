resource "kubernetes_namespace" "oauth2proxy" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "istio-injection" = "enabled"
    }
  }
}

resource "aws_cognito_user_pool" "pool" {
  name = "${var.cognito_user_pool_name}"
}

resource "aws_cognito_user_pool_client" "client" {
  name = "${var.cognito_user_pool_name}"
  user_pool_id = aws_cognito_user_pool.pool.id
  callback_urls = ["https://${var.callback_domain}/oauth2/callback"]
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["phone", "email", "openid", "profile"]

}

resource "aws_route53_record" "auth-cognito-A" {
  name    = aws_cognito_user_pool_domain.main.domain
  type    = "A"
  zone_id = data.aws_route53_zone.kubeflow_aws.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.main.cloudfront_distribution_arn
    # This zone_id is fixed
    zone_id = "Z2FDTNDATAQYW2"
  }
}

resource "aws_cognito_user_pool_domain" "main" {
  domain          = "${var.cognito_user_pool_domain}"
  certificate_arn = aws_acm_certificate.cert.arn
  user_pool_id    = aws_cognito_user_pool.pool.id
}

data "aws_route53_zone" "kubeflow_aws" {
  name = "kubeflow-aws.com"
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.cognito_user_pool_domain}"
  validation_method = "DNS"

  tags = {
    Environment = "prod"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_cognito_user_pool_client" "client" {
#   callback_urls = ["https://${var.callback_domain}/oauth2/callback"]
# }
# data "aws_eks_cluster" "cluster" {
#   name = var.cluster_name
# }

# module "assumable_role_postgres" {
#   source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
#   version                       = "3.14.0"
#   create_role                   = true
#   role_name                     = "${var.cluster_name}-${var.role_name}"
#   provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
#   role_policy_arns              = [aws_iam_policy.postgres.arn]
#   oidc_subjects_with_wildcards = [
#     "system:serviceaccount:*:${var.postgres_serviceaccount}",
#     "system:serviceaccount:*:postgres-pod"
#   ]
# }

# resource "aws_iam_policy" "postgres" {
#   name_prefix = "postgres"
#   description = "policy for postgres operator resources"
#   policy      = data.aws_iam_policy_document.postgres.json
# }

# resource "aws_s3_bucket" "wal" {
#   bucket = var.wal_bucket
#   acl    = "private"
# }

# data "aws_iam_policy_document" "postgres" {
#   statement {
#     sid    = "admin"
#     effect = "Allow"
#     actions = ["s3:*"]

#     resources = [
#       "arn:aws:s3:::${var.wal_bucket}",
#       "arn:aws:s3:::${var.wal_bucket}/*"
#     ]
#   }
# }