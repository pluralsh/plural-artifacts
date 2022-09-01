variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "airflow"
}

variable "airflow_bucket" {
  type = string
  description = "name of the bucket to use"
}

variable "minio_namespace" {
  type = string
  default = "minio"
}

variable "minio_region" {
  description = "Default MinIO region"
  default     = "us-east-1"
}

variable "minio_server" {
  description = "Default MinIO host and port"
  default = "minio.minio:9000"
}