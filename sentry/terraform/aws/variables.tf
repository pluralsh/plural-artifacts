variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "sentry"
}

variable "sentry_serviceaccount" {
  type = string
  default = "sentry"
  description = "name of the k8s service account for sentry"
}

variable "filestore_bucket" {
  type = string
}

variable "role_name" {
  type = string
  default = "sentry"
  description = "name of the IAM role for sentry to assume"
}