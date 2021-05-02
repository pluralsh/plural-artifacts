variable "subnet_name" {
  type = string
  default = "plural-subnet"
}

variable "resource_group" {
  type = string
}

variable "ad_application" {
  type = string
}

variable "address_space" {
  type = string
  default = "10.0.0.0/16"
}

variable "subnet_prefixes" {
  type = list(string)
  default = ["10.0.1.0/24"]
}

variable "name" {
  type = string
  default = "plural"
}

variable "os_disk_size" {
  type = number
  default = 50
}

variable "private_cluster" {
  type = boolean
  default = false
}

variable "min_nodes" {
  type = number
  default = 2
}

variable "max_nodes" {
  type = number
  default = 5
}