variable "namespace" {
  type = string
  default = "growthbook"
}

variable "cluster_name" {
  type = string
}

variable "growthbook_bucket" {
  type = string
  default = "growthbook"
}

variable "minio_region" {
  description = "Default MinIO region"
  default     = "us-east-1"
}

variable "minio_server" {
  description = "Default MinIO host and port"
  default = "minio.minio:9000"
}