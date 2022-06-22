variable "namespace" {
  type = string
  default = "minio"
}

variable "minio_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "minio_serviceaccount" {
  type = string
  default = "minio"
}

variable "role_name" {
  type = string
  default = "minio"
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
    ami_release_version = "1.21.5-20220123"
    force_update_version = true
    ami_type = "AL2_x86_64"
    k8s_labels = {}
    k8s_taints = []
  }
}

variable "single_az_node_groups" {
  type = any
  default = {
    local_hdd_small_on_demand = {
      name = "local-hdd-small-on-demand"
      capacity_type = "ON_DEMAND"
      min_capacity = 3
      max_capacity = 3
      desired_capacity = 3
      ami_type = "AL2_x86_64_GPU"
      instance_types = ["d3.xlarge"]
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "local-hdd-small-on-demand"
      }
      k8s_taints = [
        {
          key = "localdisk"
          value = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
  }
  description = "Node groups to add to your cluster. A single managed node group will be created in each availability zone."
}

variable "private_subnets" {
  description = "A list of private subnets for the EKS worker groups."
  type        = list(any)
  default     = []
}
