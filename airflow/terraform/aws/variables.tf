variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "airflow"
}

variable "airflow_serviceaccount" {
  type = string
  default = "airflow"
}

variable "airflow_bucket" {
  type = string
  documentation = "name of the bucket to use"
}

variable "role_name" {
  type = string
  default = "airflow"
}