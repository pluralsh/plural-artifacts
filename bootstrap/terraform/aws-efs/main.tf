data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

data "aws_vpc" "cluster_vpc" {
  # for_each = { for vpc in data.aws_eks_cluster.cluster.vpc_config : vpc.vpc_id => vpc }
  id = data.aws_eks_cluster.cluster.vpc_config[0].vpc_id
}

data "aws_subnet_ids" "cluster_private_subnets" {
  vpc_id = data.aws_vpc.cluster_vpc.id
  filter {
    name   = "tag:Name"
    values = ["${var.cluster_name}-private-*"]
  }
}

locals {
  subnet_ids = flatten([
    for vpc_key, vpc in data.aws_eks_cluster.cluster.vpc_config : [
      for subnet_key, subnet_id in vpc.subnet_ids : {
        vpc_key = vpc_key
        subnet_key  = subnet_key
        subnet_id = subnet_id
      }
    ]
  ])
}

module "assumable_role_efs" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_description              = "EFS CSI Driver Role"
  role_name                     = "${var.cluster_name}-efs"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.efs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.efs_csi_serviceaccount}"]
}

resource "aws_iam_policy" "efs_csi_policy" {
  name_prefix = "efs-csi"
  description = "EKS EFS CSI policy for cluster ${data.aws_eks_cluster.cluster.id}"
  policy      = data.aws_iam_policy_document.efs_csi.json
}

data "aws_iam_policy_document" "efs_csi" {
  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:DescribeAccessPoints",
      "elasticfilesystem:DescribeFileSystems"
    ]
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:CreateAccessPoint"
    ]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/efs.csi.aws.com/cluster"
      values = [
        "true"
      ]
    }
  }

  statement {
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "elasticfilesystem:DeleteAccessPoint"
    ]

    condition {
      test     = "StringLike"
      variable = "aws:ResourceTag/efs.csi.aws.com/cluster"
      values = [
        "true"
      ]
    }
  }
}

resource "aws_security_group" "allow_nfs" {
  name        = "allow_nfs-${var.cluster_name}"
  description = "Allow TLS inbound traffic"
  vpc_id = data.aws_vpc.cluster_vpc.id

  # for_each = data.aws_eks_cluster.cluster.vpc_config
  # for_each = { for vpc in data.aws_eks_cluster.cluster.vpc_config : vpc.vpc_id => vpc }

  ingress {
      description      = "NFS from VPC"
      from_port        = 2049
      to_port          = 2049
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.cluster_vpc.cidr_block]
      # security_groups = data.aws_eks_cluster.cluster.vpc_config[0].security_group_ids
    }
  

  egress {
      description      = "NFS to VPC"
      from_port        = 2049
      to_port          = 2049
      protocol         = "tcp"
      cidr_blocks      = [data.aws_vpc.cluster_vpc.cidr_block]
      # security_groups = data.aws_eks_cluster.cluster.vpc_config[0].security_group_ids
    }
}

resource "aws_efs_file_system" "efs_main" {
  performance_mode = "generalPurpose"
  throughput_mode = "bursting"

}

resource "aws_efs_mount_target" "efs_mount_target" {

  # for_each = { for subnet_id in local.subnet_ids : "${subnet_id.vpc_key}.${subnet_id.subnet_key}" => subnet_id }

  for_each = data.aws_subnet_ids.cluster_private_subnets.ids

  file_system_id = aws_efs_file_system.efs_main.id
  subnet_id      = each.value
  security_groups = [aws_security_group.allow_nfs.id]
}
