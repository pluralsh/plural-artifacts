variable "namespace" {
  type = string
  default = "oncall"
}

variable "cluster_name" {
  type = string
}

variable "rabbitmq_namespace" {
  type = string
  default = "rabbitmq"
}

variable "rabbitmq_secret" {
  type = string
  default = "rabbitmq-default-user"
}
