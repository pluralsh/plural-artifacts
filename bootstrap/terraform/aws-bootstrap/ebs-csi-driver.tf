module "assumable_role_ebs_csi" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-ebs-csi"
  provider_url                  = replace(module.cluster.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.ebs_csi.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${var.namespace}:${var.ebs_csi_serviceaccount}"]
}

resource "aws_iam_policy" "ebs_csi" {
  name_prefix = "ebs-csi"
  description = "EKS EBS CSI policy for cluster ${module.cluster.cluster_id}"
  policy      = data.aws_iam_policy_document.ebs_csi.json
}

data "aws_iam_policy_document" "ebs_csi" {
  statement {
    sid    = "ebsCSIAll"
    effect = "Allow"

    actions = [
      "ec2:CreateSnapshot",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ebsCSICreateTags"
    effect = "Allow"

    actions = [
      "ec2:CreateTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateVolume", "CreateVolume"]
    }
  }

  statement {
    sid    = "ebsCSIDeleteTags"
    effect = "Allow"

    actions = [
      "ec2:DeleteTags",
    ]

    resources = [
      "arn:aws:ec2:*:*:volume/*",
      "arn:aws:ec2:*:*:snapshot/*"
    ]
  }

  statement {
    sid    = "ebsCSICreateVolume"
    effect = "Allow"

    actions = [
      "ec2:CreateVolume",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }

    condition {
      test     = "StringLike"
      variable = "aws:RequestTag/CSIVolumeName"
      values   = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.cluster.cluster_id}"
      values   = ["owned"]
    }
  }

  statement {
    sid    = "ebsCSIDeleteVolume"
    effect = "Allow"

    actions = [
      "ec2:DeleteVolume",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeName"
      values   = ["*"]
    }

    condition {
      test     = "StringEquals"
      variable = "ec2:ResourceTag/kubernetes.io/cluster/${module.cluster.cluster_id}"
      values   = ["owned"]
    }
  }

  statement {
    sid    = "ebsCSIDeleteSnapshot"
    effect = "Allow"

    actions = [
      "ec2:DeleteSnapshot",
    ]

    resources = ["*"]

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/CSIVolumeSnapshotName"
      values   = ["*"]
    }

    condition {
      test     = "StringLike"
      variable = "ec2:ResourceTag/ebs.csi.aws.com/cluster"
      values   = ["true"]
    }
  }
}
