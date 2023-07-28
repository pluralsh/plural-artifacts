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
    disk_size      = 50
    #ami_release_version  = "1.22.15-20221222"
    force_update_version = true
    #ami_type             = "AL2_x86_64"
    k8s_labels = {}
    k8s_taints = []
  }
}

variable "single_az_node_groups" {
  type = any
  default = {
    sysbox_small_burst_on_demand = {
      name            = "sysbox-small-burst-ondemand"
      capacity_type   = "ON_DEMAND"
      instance_types  = ["t3.large", "t3a.large"]
      ami_filter_name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      ami_type        = "CUSTOM"
      k8s_labels = {
        "plural.sh/capacityType"    = "ON_DEMAND"
        "plural.sh/performanceType" = "SUSTAINED"
        "plural.sh/scalingGroup"    = "sysbox-small-burst-ondemand"
      }
      k8s_taints = [{
        key    = "plural.sh/sysbox"
        value  = "true"
        effect = "NO_SCHEDULE"
        }, {
        key    = "plural.sh/capacityType"
        value  = "ON_DEMAND"
        effect = "NO_SCHEDULE"
      }]
    }
  }
  description = "Node groups to add to your cluster. A single managed node group will be created in each availability zone."
}

variable "launch_templates" {
  type = any
  default = {
    sysbox_small_burst_on_demand = {
      launch_template_name = "sysbox-small-burst-ondemand"
      ami_filter_name      = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
      #ebs_optimized        = try(each.value.ebs_optimized, null)
      # optional
      #key_name                               = try(each.value.key_name, null)
      #vpc_security_group_ids                 = try(each.value.vpc_security_group_ids, [])
      #cluster_primary_security_group_id      = try(each.value.cluster_primary_security_group_id, null)
      #launch_template_default_version        = try(each.value.launch_template_default_version, null)
      #update_launch_template_default_version = try(each.value.update_launch_template_default_version, true)
      #disable_api_termination                = try(each.value.disable_api_termination, null)
      #kernel_id                              = try(each.value.kernel_id, null)
      #ram_disk_id                            = try(each.value.ram_disk_id, null)
      block_device_mappings = {
        device_name = "/dev/xvda"
        ebs = {
          volume_size           = 50
          volume_type           = "gp2"
          delete_on_termination = true
        }
      }
      #capacity_reservation_specification     = try(each.value.capacity_reservation_specification, {})
      #cpu_options                            = try(each.value.cpu_options, {})
      #credit_specification                   = try(each.value.credit_specification, {})
      elastic_gpu_specifications    = {}
      elastic_inference_accelerator = {}
      #enclave_options                        = try(each.value.enclave_options, {})
      #instance_market_options                = try(each.value.instance_market_options, {})
      #maintenance_options                    = try(each.value.maintenance_options, {})
      license_specifications = {}
      #metadata_options                       = try(each.value.metadata_options, {})
      #enable_monitoring                      = try(each.value.enable_monitoring, null)
      #network_interfaces                     = try(each.value.network_interfaces, [])
      #placement                              = try(each.value.placement, {})
      #private_dns_name_options               = try(each.value.private_dns_name_options, {})
      #launch_template_tags                   = try(each.value.launch_template_tags, {})
      #tag_specifications                     = try(each.value.tag_specifications, [])
      # the following are required if you need custom user data in you launch template, e.g. because you're using custom AMI 
      enable_bootstrap_user_data = true
      #cluster_name               = try(each.value.cluster_name, "")
      #cluster_endpoint           = try(each.value.cluster_endpoint, "")
      #cluster_auth_base64        = try(each.value.cluster_auth_base64, "")
      # this is optional if you're using a custom 
      #cluster_service_ipv4_cidr = try(each.value.cluster_service_ipv4_cidr, null)
      #pre_bootstrap_user_data   = try(each.value.pre_bootstrap_user_data, "")
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
        #  "eks.amazonaws.com/capacityType=ON_DEMAND",
        #  "plural.sh/capacityType=ON_DEMAND",
        #  "eks.amazonaws.com/nodegroup=buildx-spot-x86",
        #  "plural.sh/performanceType=BURST",
        #  "eks.amazonaws.com/nodegroup=plural-worker-medium-us-east-2c-subnet-09231904575210d72"
        #]
        #"--register-with-taints" = [
        #  "plural.sh/reserved=BUILDX:NoSchedule",
        #  "plural.sh/capacityType=SPOT:NoSchedule"
        #]
      }
    }
  }
}
