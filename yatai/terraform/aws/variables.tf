variable "namespace" {
  type    = string
  default = "yatai-system"
}

variable "cluster_name" {
  type = string
}

variable "bucket" {
  type = string
}

variable "role_name" {
  type    = string
  default = "yatai"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}

variable "yatai_serviceaccount" {
  type    = string
  default = "yatai"
}

variable "yatai_deployment_serviceaccount" {
  type    = string
  default = "yatai-yatai-deployment"
}

variable "yatai_image_builder_serviceaccount" {
  type    = string
  default = "yatai-yatai-image-builder"
}
