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
    sysbox_s_ondemand = {
      name           = "sysbox-s-ondemand"
      capacity_type  = "ON_DEMAND"
      instance_types = ["t3.large", "t3a.large"]
      ami_type       = "CUSTOM"
      k8s_labels = {
        "plural.sh/capacityType"    = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup"    = "sysbox-s-ondemand"
        "sysbox-install"            = "yes"
      }
      k8s_taints = [{
        key    = "plural.sh/sysbox"
        value  = "true"
        effect = "NO_SCHEDULE"
        }, {
        key    = "plural.sh/capacityType"
        value  = "ON_DEMAND"
        effect = "NO_SCHEDULE"
        }
        #eks.amazonaws.com/nodegroup=small-burst-on-demand-us-east-2c-subnet-09231904575210d72
      ]
    }
  }
  description = "Node groups to add to your cluster. A single managed node group will be created in each availability zone."
}

variable "launch_templates" {
  type = any
  default = {
    sysbox_s_ondemand = {
      launch_template_name = "sysbox-s-ondemand"
      #ami_filter_name      = "ubuntu-eks/k8s_1.23/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      ami_filter_name = "latch-bio/sysbox-eks_0.6.2/k8s_1.23/images/hvm-ssd/ubuntu-focal-20.04-amd64-server"
      ami_owners      = ["099720109477"] # Canonical
      #owners = ["312272277431"] # Plural
      #ebs_optimized                          = null
      create_key_pair = true
      #key_name                               = null
      #vpc_security_group_ids                 = null
      #cluster_primary_security_group_id      = null
      #launch_template_default_version        = null
      #update_launch_template_default_version = null
      #disable_api_termination                = null
      #kernel_id                              = null
      #ram_disk_id                            = null
      block_device_mappings = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 50
          volume_type           = "gp2"
          delete_on_termination = true
        }
      }
      #capacity_reservation_specification     = {}
      #cpu_options                            = {}
      #credit_specification                   = {}
      elastic_gpu_specifications    = {}
      elastic_inference_accelerator = {}
      #enclave_options                        = {}
      #instance_market_options                = {}
      #maintenance_options                    = {}
      license_specifications = {}
      #metadata_options                       = {}
      #enable_monitoring                      = {}
      #network_interfaces                     = {}
      #placement                              = {}
      #private_dns_name_options               = {}
      #launch_template_tags                   = {}
      #tag_specifications                     = {}
      # the following are required if you need custom user data in you launch template, e.g. because you're using custom AMI 
      enable_bootstrap_user_data = true
      #cluster_name               = ""
      #cluster_endpoint           = ""
      #cluster_auth_base64        = ""
      # this is optional if you're using a custom 
      #cluster_service_ipv4_cidr = ""
      #pre_bootstrap_user_data   = ""
      post_bootstrap_user_data = <<-EOT
        echo "All done"
      EOT
      # TODO: actually make this a map in the vars, easier for kubelet args
      #bootstrap_extra_args = try(each.value.bootstrap_extra_args, "")
      k8s_labels = {} # leave empty, will reuse the same labels as the node group
      k8s_taints = [] # leave empty, will reuse the same taints as the node group
      kubelet_extra_args = {
        #"--node-labels" = [
        #  "plural.sh/scalingGroup=buildx-spot-x86",
        #  "plural.sh/capacityType=ON_DEMAND",
        #  "plural.sh/performanceType=BURST",
        #]
        #"--register-with-taints" = [
        #  "plural.sh/reserved=BUILDX:NoSchedule",
        #  "plural.sh/capacityType=SPOT:NoSchedule"
        #]
      }
      max_pods_per_node = 16
    }
  }
}

variable "private_subnets" {
  description = "A list of private subnets for the EKS worker groups."
  type        = list(any)
  default     = []
}
