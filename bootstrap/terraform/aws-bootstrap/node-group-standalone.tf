
module "node_groups" {
  source                 = "github.com/pluralsh/terraform-aws-eks//modules/node_groups?ref=asg-tags"
  cluster_name           = var.cluster_name
  default_iam_role_arn   = module.cluster.worker_iam_role_arn
  workers_group_defaults = {
    asg_desired_capacity = "1"
    instance_type = "t3.large"
    key_name = ""
    launch_template_id = null
    launch_template_version = "$Latest"
    asg_max_size = "3"
    asg_min_size = "1"
    subnets = module.vpc.worker_private_subnets[*].id
  }
  tags                   = {}
  node_groups_defaults   = {
    desired_capacity = var.desired_capacity
    min_capacity = var.min_capacity
    max_capacity = var.max_capacity

    instance_types = var.instance_types
    disk_size = 50
    subnets = module.vpc.worker_private_subnets[*].id
    ami_release_version = "1.21.5-20220123"
    force_update_version = true
    ami_type = "AL2_x86_64"
    k8s_labels = {}
    k8s_taints = []
  }

  node_groups            = var.multi_az_node_groups
  set_desired_size       = false
  # subnets        = module.vpc.worker_private_subnets[*].id

  # Hack to ensure ordering of resource creation.
  # This is a homemade `depends_on` https://discuss.hashicorp.com/t/tips-howto-implement-module-depends-on-emulation/2305/2
  # Do not create node_groups before other resources are ready and removes race conditions
  # Ensure these resources are created before "unlocking" the data source.
  # Will be removed in Terraform 0.13
  ng_depends_on = [
    module.cluster.cluster_id
  ]
}
