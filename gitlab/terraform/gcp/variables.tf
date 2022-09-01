variable "cluster_name" {
  type = string
  default = "plural"
}

variable "namespace" {
  type = string
  default = "gitlab"
}

variable "gcp_region" {
  type = string
  default = "us-east1"
  description = <<EOF
The region you wish to deploy to
EOF
}

variable "bucket_location" {
  type = string
  default = "US"
  description = "the location of the bucket"
}

variable "project_id" {
  type = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
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