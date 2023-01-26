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

variable "terraform_bucket" {
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

variable "force_destroy_registry_bucket" {
  type        = bool
  default     = true
  description = "If true, the registry bucket will be deleted even if it contains objects."
}

variable "force_destroy_lfs_bucket" {
  type        = bool
  default     = true
  description = "If true, the lfs bucket will be deleted even if it contains objects."
}

variable "force_destroy_artifacts_bucket" {
  type        = bool
  default     = true
  description = "If true, the artifacts bucket will be deleted even if it contains objects."
}

variable "force_destroy_packages_bucket" {
  type        = bool
  default     = true
  description = "If true, the packages bucket will be deleted even if it contains objects."
}

variable "force_destroy_backups_bucket" {
  type        = bool
  default     = true
  description = "If true, the backups bucket will be deleted even if it contains objects."
}

variable "force_destroy_backups_tmp_bucket" {
  type        = bool
  default     = true
  description = "If true, the backups tmp bucket will be deleted even if it contains objects."
}

variable "force_destroy_uploads_bucket" {
  type        = bool
  default     = true
  description = "If true, the uploads bucket will be deleted even if it contains objects."
}

variable "force_destroy_terraform_state_bucket" {
  type        = bool
  default     = true
  description = "If true, the terraform state bucket will be deleted even if it contains objects."
}

variable "force_destroy_runner_cache_bucket" {
  type        = bool
  default     = true
  description = "If true, the runner cache bucket will be deleted even if it contains objects."
}
