variable "namespace" {
  type = string
  default = "mlflow"
}

variable "mlflow_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "role_name" {
  type = string
  default = "mlflow"
}

variable "serviceaccount_name" {
  type = string
  default = "mlflow"
}
