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
