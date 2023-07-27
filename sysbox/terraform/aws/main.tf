resource "kubernetes_namespace" "sysbox" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "sysbox"

    }
  }
}

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

module "node_groups" {
  source               = "github.com/pluralsh/module-library//terraform/eks-node-groups/single-az-node-groups?ref=feat-ubuntu-ng"
  cluster_name         = var.cluster_name
  default_iam_role_arn = data.aws_eks_node_group.main.node_role_arn
  tags                 = var.tags
  node_groups_defaults = var.node_groups_defaults
  node_groups          = var.single_az_node_groups
  launch_templates     = var.launch_templates
  set_desired_size     = false
  #private_subnets      = data.aws_eks_node_group.main.subnet_idss
}
