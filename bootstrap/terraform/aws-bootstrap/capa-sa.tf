module "asummable_role_capa" {
  #   count = var.enable_cluster_capa ? 1 : 0

  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-capa-controller"
  provider_url                  = replace(local.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.capa_controller.arn, aws_iam_policy.capa_controller_eks.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.capa_serviceaccount}", "system:serviceaccount:${var.namespace}:${var.capi_serviceaccount}"]
}

resource "aws_iam_policy" "capa_controller" {
  #   count = var.enable_cluster_capa ? 1 : 0

  name_prefix = "cluster-capa"
  description = "EKS cluster api provider aws policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.capa_controller.json
}

resource "aws_iam_policy" "capa_controller_eks" {
  #   count = var.enable_cluster_capa ? 1 : 0

  name_prefix = "cluster-capa"
  description = "EKS cluster api provider aws policy for cluster ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.capa_controller_eks.json
}

data "aws_iam_policy_document" "capa_controller" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AttachNetworkInterface",
      "ec2:DetachNetworkInterface",
      "ec2:AllocateAddress",
      "ec2:AssignIpv6Addresses",
      "ec2:AssignPrivateIpAddresses",
      "ec2:UnassignPrivateIpAddresses",
      "ec2:AssociateRouteTable",
      "ec2:AttachInternetGateway",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateInternetGateway",
      "ec2:CreateEgressOnlyInternetGateway",
      "ec2:CreateNatGateway",
      "ec2:CreateNetworkInterface",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVpc",
      "ec2:ModifyVpcAttribute",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteEgressOnlyInternetGateway",
      "ec2:DeleteNatGateway",
      "ec2:DeleteRouteTable",
      "ec2:ReplaceRoute",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSubnet",
      "ec2:DeleteTags",
      "ec2:DeleteVpc",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeEgressOnlyInternetGateways",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeImages",
      "ec2:DescribeNatGateways",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeNetworkInterfaceAttribute",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags",
      "ec2:DetachInternetGateway",
      "ec2:DisassociateRouteTable",
      "ec2:DisassociateAddress",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:ModifySubnetAttribute",
      "ec2:ReleaseAddress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "tag:GetResources",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:ConfigureHealthCheck",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RemoveTags",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeInstanceRefreshes",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteLaunchTemplateVersions",
      "ec2:DescribeKeyPairs",
      "ec2:ModifyInstanceMetadataOptions",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/*"]

    actions = [
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:StartInstanceRefresh",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteTags",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:iam::*:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["autoscaling.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:iam::*:role/aws-service-role/elasticloadbalancing.amazonaws.com/AWSServiceRoleForElasticLoadBalancing"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["elasticloadbalancing.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:iam::*:role/aws-service-role/spot.amazonaws.com/AWSServiceRoleForEC2Spot"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["spot.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:iam::*:role/*.cluster-api-provider-aws.sigs.k8s.io"]
    actions   = ["iam:PassRole"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:secretsmanager:*:*:secret:aws.cluster.x-k8s.io/*"]

    actions = [
      "secretsmanager:CreateSecret",
      "secretsmanager:DeleteSecret",
      "secretsmanager:TagResource",
    ]
  }
}

data "aws_iam_policy_document" "capa_controller_eks" {

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:ssm:*:*:parameter/aws/service/eks/optimized-ami/*"]
    actions   = ["ssm:GetParameter"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:iam::*:role/aws-service-role/eks.amazonaws.com/AWSServiceRoleForAmazonEKS"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["eks.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:iam::*:role/aws-service-role/eks-nodegroup.amazonaws.com/AWSServiceRoleForAmazonEKSNodegroup"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["eks-nodegroup.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:iam::*:role/aws-service-role/eks-fargate-pods.amazonaws.com/AWSServiceRoleForAmazonEKSForFargate"]
    actions   = ["iam:CreateServiceLinkedRole"]

    condition {
      test     = "StringLike"
      variable = "iam:AWSServiceName"
      values   = ["eks-fargate.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "iam:ListOpenIDConnectProviders",
      "iam:GetOpenIDConnectProvider",
      "iam:CreateOpenIDConnectProvider",
      "iam:AddClientIDToOpenIDConnectProvider",
      "iam:UpdateOpenIDConnectProviderThumbprint",
      "iam:DeleteOpenIDConnectProvider",
      "iam:TagOpenIDConnectProvider",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:*:iam::*:role/*"]

    actions = [
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:DetachRolePolicy",
      "iam:DeleteRole",
      "iam:CreateRole",
      "iam:TagRole",
      "iam:UntagRole",
      "iam:AttachRolePolicy",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = [
      "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
      "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
      "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
      "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    ]
    actions   = ["iam:GetPolicy"]
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:*:eks:*:*:cluster/*",
      "arn:*:eks:*:*:nodegroup/*/*/*",
    ]

    actions = [
      "eks:DescribeCluster",
      "eks:ListClusters",
      "eks:CreateCluster",
      "eks:TagResource",
      "eks:UpdateClusterVersion",
      "eks:DeleteCluster",
      "eks:UpdateClusterConfig",
      "eks:UntagResource",
      "eks:UpdateNodegroupVersion",
      "eks:DescribeNodegroup",
      "eks:DeleteNodegroup",
      "eks:UpdateNodegroupConfig",
      "eks:CreateNodegroup",
      "eks:AssociateEncryptionConfig",
      "eks:ListIdentityProviderConfigs",
      "eks:AssociateIdentityProviderConfig",
      "eks:DescribeIdentityProviderConfig",
      "eks:DisassociateIdentityProviderConfig",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:AssociateVpcCidrBlock",
      "ec2:DisassociateVpcCidrBlock",
      "eks:ListAddons",
      "eks:CreateAddon",
      "eks:DescribeAddonVersions",
      "eks:DescribeAddon",
      "eks:DeleteAddon",
      "eks:UpdateAddon",
      "eks:TagResource",
      "eks:DescribeFargateProfile",
      "eks:CreateFargateProfile",
      "eks:DeleteFargateProfile",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:PassRole"]

    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values   = ["eks.amazonaws.com"]
    }
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:CreateGrant",
      "kms:DescribeKey",
    ]

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "kms:ResourceAliases"
      values   = ["alias/cluster-api-provider-aws-*"]
    }
  }
}
