variable "namespace" {
  type    = string
  default = "sysbox"
}

variable "cluster_name" {
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
    desired_capacity = 1
    min_capacity     = 1
    max_capacity     = 3

    instance_types = ["t3.large", "t3a.large"]
    # disk size must be specified in launch template
    force_update_version = true
    k8s_labels           = {}
    k8s_taints           = []
  }
}

variable "single_az_node_groups" {
  type = any
  default = {
    sysbox_s_ondemand_plural = {
      name           = "sysbox-s-ondemand-plural"
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.large", "t3a.large"]
      ami_type       = "CUSTOM"
      k8s_labels = {
        "plural.sh/capacityType"    = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup"    = "sysbox-s-ondemand-plural"
        "sysbox-install"            = "yes"
        "crio-runtime"              = "running"
        "sysbox-runtime"            = "running"
      }
      k8s_taints = [{
        key    = "plural.sh/sysbox"
        value  = "true"
        effect = "NO_SCHEDULE"
        },
      ]
    }
  }
  description = "Node groups to add to your cluster. A single managed node group will be created in each availability zone."
}

variable "launch_templates" {
  type = any
  default = {
    sysbox_s_ondemand_plural = {
      launch_template_name = "sysbox-s-ondemand-plural"
      ami_filter_name      = "pluraldev-05-cleanup-part4-crio-binary-fix2/sysbox-eks_0.6.2/k8s_1.23/images/hvm-ssd/ubuntu-focal-20.04-amd64-server"
      ami_owners           = ["312272277431"] # Plural
      create_key_pair      = true
      block_device_mappings = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 50
          volume_type           = "gp2"
          delete_on_termination = true
        }
      }
      elastic_gpu_specifications    = {}
      elastic_inference_accelerator = {}
      license_specifications        = {}
      enable_bootstrap_user_data    = true
      k8s_labels                    = {} # leave empty, will reuse the same labels as the node group
      k8s_taints                    = [] # leave empty, will reuse the same taints as the node group
      kubelet_extra_args            = {}
      max_pods_per_node             = 16
    }
  }
}

variable "private_subnets" {
  description = "A list of private subnets for the EKS worker groups."
  type        = list(any)
  default     = []
}
