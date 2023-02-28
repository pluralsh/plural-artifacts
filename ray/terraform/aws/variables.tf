variable "namespace" {
  type = string
  default = "ray"
}

variable "cluster_name" {
  type = string
}

variable "create_single_az_node_groups" {
  type = bool
  default = false
}

variable "node_role_arn" {
  type = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "node_groups_defaults" {
  description = "map of maps of node groups to create. See \"`node_groups` and `node_groups_defaults` keys\" section in README.md for more details"
  type        = any
  default = {
    desired_capacity = 0
    min_capacity = 0
    max_capacity = 3

    instance_types = ["t3.large", "t3a.large"]
    disk_size = 50
    ami_release_version = "1.22.15-20221222"
    force_update_version = true
    ami_type = "AL2_x86_64"
    k8s_labels = {}
    k8s_taints = []
  }
}

variable "single_az_node_groups" {
  type = any
  default = {
    ray_small_burst_spot = {
      name = "ray-small-burst-spot"
      capacity_type = "SPOT"
      instance_types = ["t3.large", "t3a.large"]
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "BURST"
        "plural.sh/scalingGroup" = "ray-small-burst-spot"
      }
      k8s_taints = [{
        key = "plural.sh/capacityType"
        value = "SPOT"
        effect = "NO_SCHEDULE"
      }]
    }
  }
  description = "Node groups to add to your cluster. A single managed node group will be created in each availability zone."
}

variable "private_subnets" {
  description = "A list of private subnets for the EKS worker groups."
  type        = list(any)
  default     = []
}
