variable "namespace" {
  type = string
  default = "airbyte"
}

variable "airbyte_bucket" {
  type = string
  default = "airbyte"
}

variable "minio_namespace" {
  type = string
}

variable "minio_region" {
  description = "Default MinIO region"
  default     = "us-east-1"
}

variable "minio_server" {
  description = "Default MinIO host and port"
  default = "minio.minio:9000"
}
