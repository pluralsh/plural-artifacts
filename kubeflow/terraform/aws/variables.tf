variable "namespace" {
  type = string
  default = "kubeflow"
}

variable "pipelines_bucket" {
  type = string
}

variable "cluster_name" {
  type = string
  default = "plural"
}

variable "kubeflow_argo_serviceaccount" {
  type = string
  default = "kubeflow-pipelines-argo-workflow-controller"
}

variable "force_destroy_pipelines_bucket" {
  type        = bool
  default     = true
  description = "If true, the bucket will be deleted even if it contains objects."
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
    gpu_inf_small_on_demand = {
      name = "gpu-inf-small-on-demand"
      capacity_type = "ON_DEMAND"
      min_capacity = 0
      max_capacity = 3
      desired_capacity = 0
      ami_type = "AL2_x86_64_GPU"
      instance_types = ["g4dn.xlarge"]
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "gpu-inf-small-on-demand"
        "k8s.amazonaws.com/accelerator" = "nvidia-tesla-t4"
      }
      k8s_taints = [
        {
          key = "nvidia.com/gpu"
          value = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
    gpu_inf_small_spot = {
      name = "gpu-inf-small-spot"
      capacity_type = "SPOT"
      min_capacity = 0
      max_capacity = 3
      desired_capacity = 0
      ami_type = "AL2_x86_64_GPU"
      instance_types = ["g4dn.xlarge"]
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "gpu-inf-small-spot"
        "k8s.amazonaws.com/accelerator" = "nvidia-tesla-t4"
      }
      k8s_taints = [
        {
          key = "plural.sh/capacityType"
          value = "SPOT"
          effect = "NO_SCHEDULE"
        },
        {
          key = "nvidia.com/gpu"
          value = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
    gpu_small_on_demand = {
      name = "gpu-small-on-demand"
      capacity_type = "ON_DEMAND"
      min_capacity = 0
      max_capacity = 3
      desired_capacity = 0
      ami_type = "AL2_x86_64_GPU"
      instance_types = ["p3.2xlarge"]
      k8s_labels = {
        "plural.sh/capacityType" = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "gpu-small-on-demand"
        "k8s.amazonaws.com/accelerator" = "nvidia-tesla-v100"
      }
      k8s_taints = [
        {
          key = "nvidia.com/gpu"
          value = "true"
          effect = "NO_SCHEDULE"
        }
      ]
    }
    gpu_small_spot = {
      name = "gpu-small-spot"
      capacity_type = "SPOT"
      min_capacity = 0
      max_capacity = 3
      desired_capacity = 0
      ami_type = "AL2_x86_64_GPU"
      instance_types = ["p3.2xlarge"]
      k8s_labels = {
        "plural.sh/capacityType" = "SPOT"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup" = "gpu-small-spot"
        "k8s.amazonaws.com/accelerator" = "nvidia-tesla-v100"
      }
      k8s_taints = [
        {
          key = "plural.sh/capacityType"
          value = "SPOT"
          effect = "NO_SCHEDULE"
        },
        {
          key = "nvidia.com/gpu"
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

variable "role_name" {
  type = string
  default = "kubeflow"
}

variable "ack_iam_role_name" {
  type = string
  default = "aws-ack-iam"
}

variable "ack_iam_sa_name" {
  type = string
  default = "ack-iam-controller"
}
