variable "namespace" {
  type = string
  default = "mlflow"
}

variable "mlflow_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "role_name" {
  type = string
  default = "mlflow"
}

variable "serviceaccount_name" {
  type = string
  default = "mlflow"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}

variable "bucket_tags" {
  type        = map(string)
  description = "tags to apply to the buckets"
  default     = {}
}

variable "enable_versioning" {
  type = bool
  description = "enable s3 object versioning"
  default = false
}