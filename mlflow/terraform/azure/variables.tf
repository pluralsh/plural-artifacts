variable "namespace" {
  type    = string
  default = "mlflow"
}

variable "cluster_name" {
  type = string
}

variable "resource_group" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "mlflow_bucket" {
  type = string
}
