variable "namespace" {
  type = string
  default = "vault"
}

variable "cluster_name" {
  type = string
}

variable "vault_serviceaccount" {
  type = string
  default = "vault"
}

variable "project_id" {
  type = string
  description = <<EOF
The ID of the project in which the resources belong.
EOF
}

variable "keyring_location" {
  default = "global"
}
