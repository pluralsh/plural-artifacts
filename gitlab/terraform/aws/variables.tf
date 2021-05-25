variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "gitlab"
}

variable "gitlab_serviceaccount" {
  type = string
  default = "gitlab"
  description = "name of the k8s service account for gitlab"
}

variable "runner_serviceaccount" {
  type = string
  default = "gitlab-runner"
  description = "name of the k8s service account for gitlab"
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

variable "uploads_bucket" {
  type = string
}

variable "runner_cache_bucket" {
  type = string
}

variable "role_name" {
  type = string
  default = "gitlab"
  description = "name of the IAM role for gitlab to assume"
}

variable "runner_role_name" {
  type = string
  default = "gitlab-runner"
  description = "name of the IAM role for gitlab to assume"
}