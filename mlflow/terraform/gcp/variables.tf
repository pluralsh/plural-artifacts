variable "namespace" {
  type = string
  default = "mlflow"
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "serviceaccount_name" {
  type = string
  default = "mlflow"
}

variable "role_name" {
  type = string
  default = "mlflow"
}

variable "mlflow_bucket" {
  type = string
}

variable "gcp_region" {
  type = string
  default = "us-east1"
  description = "The region you wish to deploy to"
}

variable "bucket_location" {
  type = string
  default = "US"
  description = "the location of the bucket"
}

variable "project_id" {
  type = string
  description = "The ID of the project in which the resources belong."
}
