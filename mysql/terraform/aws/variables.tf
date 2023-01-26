variable "namespace" {
  type = string
  default = "mysql"
}

variable "backup_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "mysql_serviceaccount" {
  type = string
  default = "mysql-operator"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
