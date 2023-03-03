variable "namespace" {
  type = string
  default = "posthog"
}

variable "cluster_name" {
  type = string
}

variable "posthog_bucket" {
  type = string
  default = "posthog"
}
