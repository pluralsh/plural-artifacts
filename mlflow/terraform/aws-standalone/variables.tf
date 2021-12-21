variable "mlflow_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "mlflow_serviceaccount" {
  type = string
  default = "mlflow"
}

variable "role_name" {
  type = string
  default = "mlflow"
}
