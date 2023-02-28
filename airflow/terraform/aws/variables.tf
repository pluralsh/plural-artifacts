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
  description = "name of the k8s service account for airflow"
}

variable "airflow_bucket" {
  type = string
  description = "name of the bucket to use"
}

variable "role_name" {
  type = string
  default = "airflow"
  description = "name of the IAM role for airflow to assume"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
