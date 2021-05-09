locals {
  node_pool_name = substr(replace("${var.name}nodes", "-", ""), 0, 12)
}