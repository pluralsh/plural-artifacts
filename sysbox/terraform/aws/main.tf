
data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_eks_node_groups" "cluster" {
  cluster_name = var.cluster_name
}

data "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = tolist(data.aws_eks_node_groups.cluster.names)[0]
}

module "launch_templates" {
  source   = "github.com/pluralsh/module-library//terraform/eks-node-groups/launch-template?ref=eks-node-groups-v1.0.0"
  for_each = var.launch_templates

  tags = try(each.value.tags, {})
  # required
  launch_template_name            = try(each.value.launch_template_name, join("-", [var.cluster_name, each.key]))
  launch_template_use_name_prefix = try(each.value.launch_template_use_name_prefix, false)
  launch_template_description     = try(each.value.launch_template_description, null)
  ebs_optimized                   = try(each.value.ebs_optimized, false)
  # one of the following must be specified, either ami_id or a combination of ami_filter_name & ami_owners 
  ami_id          = try(each.value.ami_id, null)
  ami_filter_name = try(each.value.ami_filter_name, null)
  ami_owners      = try(each.value.ami_owners, [])
  # optional
  create_key_pair                        = try(each.value.create_key_pair, false)
  key_name                               = try(each.value.key_name, null)
  vpc_security_group_ids                 = try(each.value.vpc_security_group_ids, [])
  cluster_primary_security_group_id      = try(each.value.cluster_primary_security_group_id, null)
  launch_template_default_version        = try(each.value.launch_template_default_version, null)
  update_launch_template_default_version = try(each.value.update_launch_template_default_version, true)
  disable_api_termination                = try(each.value.disable_api_termination, null)
  kernel_id                              = try(each.value.kernel_id, null)
  ram_disk_id                            = try(each.value.ram_disk_id, null)
  block_device_mappings                  = try(each.value.block_device_mappings, {})
  capacity_reservation_specification     = try(each.value.capacity_reservation_specification, {})
  cpu_options                            = try(each.value.cpu_options, {})
  credit_specification                   = try(each.value.credit_specification, {})
  elastic_gpu_specifications             = try(each.value.elastic_gpu_specifications, {})
  elastic_inference_accelerator          = try(each.value.elastic_inference_accelerator, {})
  enclave_options                        = try(each.value.enclave_options, {})
  instance_market_options                = try(each.value.instance_market_options, {})
  maintenance_options                    = try(each.value.maintenance_options, {})
  license_specifications                 = try(each.value.license_specifications, {})
  metadata_options                       = try(each.value.metadata_options, {})
  enable_monitoring                      = try(each.value.enable_monitoring, false)
  network_interfaces                     = try(each.value.network_interfaces, [])
  placement                              = try(each.value.placement, {})
  private_dns_name_options               = try(each.value.private_dns_name_options, {})
  launch_template_tags                   = try(each.value.launch_template_tags, {})
  tag_specifications                     = try(each.value.tag_specifications, [])
  # the following are required if you need custom user data in you launch template, e.g. because you're using custom AMI 
  enable_bootstrap_user_data = try(each.value.enable_bootstrap_user_data, false)
  cluster_name               = try(each.value.cluster_name, var.cluster_name)
  cluster_endpoint           = try(each.value.cluster_endpoint, "")
  cluster_auth_base64        = try(each.value.cluster_auth_base64, "")
  # this is optional if you're using a custom 
  cluster_service_ipv4_cidr = try(each.value.cluster_service_ipv4_cidr, null)
  pre_bootstrap_user_data   = try(each.value.pre_bootstrap_user_data, "")
  post_bootstrap_user_data  = try(each.value.post_bootstrap_user_data, "")
  bootstrap_extra_args      = try(each.value.bootstrap_extra_args, "")
  kubelet_extra_args        = try(each.value.kubelet_extra_args, {})
  k8s_labels                = merge(var.multi_az_node_groups[each.key]["k8s_labels"], try(each.value.k8s_labels, {}))
  k8s_taints                = concat(var.multi_az_node_groups[each.key]["k8s_taints"], try(each.value.k8s_taints, []))
  max_pods_per_node         = try(each.value.max_pods_per_node, null)
}


module "node_groups" {
  source               = "github.com/pluralsh/module-library//terraform/eks-node-groups/multi-az-node-groups?ref=eks-node-groups-v1.0.0"
  cluster_name         = var.cluster_name
  default_iam_role_arn = data.aws_eks_node_group.main.node_role_arn
  tags                 = var.tags
  node_groups_defaults = var.node_groups_defaults
  node_groups = {
    for k, v in var.multi_az_node_groups : k => merge(
      v,
      try(var.launch_templates[k].launch_template_name, null) != null ?
      {
        launch_template_id      = module.launch_templates[k].launch_template_id
        launch_template_version = module.launch_templates[k].launch_template_latest_version
      } :
      {}
    )
  }
  set_desired_size   = false
  private_subnet_ids = var.private_subnets[*].id
  depends_on         = [module.launch_templates]
}
