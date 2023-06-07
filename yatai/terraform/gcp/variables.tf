variable "namespace" {
  type    = string
  default = "yatai"
}

variable "cluster_name" {
  type = string
}


variable "bucket" {
  type = string
}


variable "region" {
  type        = string
  default     = "us-east1"
  description = <<EOF
The region you wish to deploy to
EOF
}

variable "bucket_location" {
  type        = string
  default     = "US"
  description = "the location of the bucket"
}

variable "project_id" {
  type        = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}


variable "roles" {
  type        = list(string)
  description = "A list of roles to be added to the yatai workload identity service accounts"
  default     = []
}
