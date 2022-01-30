variable "namespace" {
  type = string
  default = "dagster"
}

variable "cluster_name" {
  type = string
}

variable "dagster_bucket" {
  type = string
}

variable "dagster_serviceaccount" {
  type = string
  default = "dagster"
}

variable "role_name" {
  type = string
  default = "dagster"
}