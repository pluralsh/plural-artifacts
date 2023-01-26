variable "namespace" {
  type = string
  default = "argo-workflows"
}

variable "workflow_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "argo_workflows_serviceaccount" {
  type = string
  default = "argo-workflows"
}

variable "role_name" {
  type = string
  default = "argo-workflows"
}

variable "force_destroy_bucket" {
  type        = bool
  default     = false
  description = "If true, the bucket will be deleted even if it contains objects."
}
