variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "postgres"
}

variable "wal_bucket" {
  type = string
}

variable "minio_region" {
  description = "Default MinIO region"
  type = string
  default     = "us-east-1"
}

variable "minio_server" {
  description = "Default MinIO host and port"
  type = string
  default = "minio.minio:9000"
}

variable "minio_ssl" {
  description = "If MinIO is using SSL"
  type = bool
  default = true
}
  
variable "minio_insecure" {
  description = "If the MinIO certificate is self-signed"
  type = bool
  default = false
}

variable "minio_access_key" {
  description = "MinIO access key"
  type = string
  sensitive = true
}

variable "minio_secret_key" {
  desdescription = "MinIO secret key"
  type = string
  sensitive = true
}
