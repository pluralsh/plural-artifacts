variable "cluster_name" {
  type = string
  default = "piazza"
}

variable "namespace" {
  type = string
  default = "console"
}

variable "console_serviceaccount" {
  type = string
  default = "console"
}

variable "role_name" {
  type = string
  default = "console"
}