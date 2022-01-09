variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "gitlab"
}

variable "resource_group" {
  type = string
}

variable "registry_bucket" {
  type = string
}

variable "artifacts_bucket" {
  type = string
}

variable "packages_bucket" {
  type = string
}

variable "backups_bucket" {
  type = string
}

variable "backups_tmp_bucket" {
  type = string
}

variable "lfs_bucket" {
  type = string
}

variable "runner_cache_bucket" {
  type = string
}

variable "terraform_bucket" {
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