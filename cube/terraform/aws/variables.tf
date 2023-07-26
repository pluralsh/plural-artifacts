variable "namespace" {
  type = string
  default = "cube"
}

variable "cluster_name" {
  type = string
}

variable "cube_bucket" {
  type = string
}

variable "cube_serviceaccount" {
  type = string
  default = "cube"
}

variable "role_name" {
  type = string
  default = "cube"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
}
