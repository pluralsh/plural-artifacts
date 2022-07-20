variable "rabbitmq_namespace" {
  type = string
  default = "rabbitmq"
}

variable "rabbitmq_secret" {
  type = string
  default = "rabbitmq-default-user"
}

variable "redis_namespace" {
  type = string
  default = "redis"
}

variable "redis_secret" {
  type = string
  default = "redis-password"
}
