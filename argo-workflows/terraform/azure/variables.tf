variable "namespace" {
  type = string
  default = "argo-workflows"
}

variable "workflow_bucket" {
  type = string
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