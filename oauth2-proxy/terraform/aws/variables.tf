variable "namespace" {
  type = string
  default = "oauth2-proxy"
}

variable "cognito_user_pool_name" {
  type = string
  default = "kubeflow"

  description = "name for the cognito user pool"
}

variable "callback_domain" {
  type = string
  default = "kubeflow.kubeflow-aws.com"

  description = "the domain for the oidc callback"
}

variable "cognito_user_pool_domain" {
  type = string
  default = "cognito.kubeflow-aws.com"

  description = "the cognito domain"
}

# variable "wal_bucket" {
#   type = string
# }

# variable "cluster_name" {
#   type = string
#   default = "plural"
# }

# variable "postgres_serviceaccount" {
#   type = string
#   default = "postgres-operator"
# }

# variable "role_name" {
#   type = string
#   default = "postgres"
# }