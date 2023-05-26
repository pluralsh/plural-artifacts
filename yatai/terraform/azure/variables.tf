variable "namespace" {
  type    = string
  default = "yatai"
}

variable "cluster_name" {
  type = string
}

variable "bucket" {
  type = string
}

variable "acl" {
  type    = string
  default = "private"
}

variable "user_name" {
  type    = string
  default = "yatai"
}

variable "minio_namespace" {
  type    = string
  default = "minio"
}

variable "minio_root_secret" {
  type    = string
  default = "minio-root-secret"
}

variable "minio_server" {
  type = string
}

variable "minio_region" {
  type        = string
  description = "Default MinIO region"
  default     = "us-east-1"
}
