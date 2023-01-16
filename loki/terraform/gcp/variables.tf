variable "namespace" {
  type = string
  default = "loki"
}

variable "cluster_name" {
  type = string
}

variable "project_id" {
  type = string
  description = "The ID of the project in which the resources belong."
}

variable "loki_bucket" {
  type = string
}

variable "bucket_location" {
  type = string
}

variable "loki_serviceaccount" {
  type = string
  default = "loki"
}
