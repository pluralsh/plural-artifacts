resource "kubernetes_namespace" "yatai" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "yatai"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

resource "kubernetes_namespace" "yatai-system" {
  metadata {
    name = "yatai-system"
    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name"           = "yatai"

      "platform.plural.sh/sync-target" = "pg"

    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "s3_buckets" {
  source        = "github.com/pluralsh/module-library//terraform/s3-buckets?ref=bucket-protection"
  bucket_names  = [var.bucket]
  policy_prefix = "yatai"
  force_destroy = var.force_destroy_bucket
}

module "assumable_role_yatai" {
  source           = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version          = "3.14.0"
  create_role      = true
  role_name        = "${var.cluster_name}-${var.role_name}"
  provider_url     = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns = [module.s3_buckets.policy_arn]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${var.namespace}:${var.yatai_serviceaccount}",
    "system:serviceaccount:${var.namespace}:${var.yatai_deployment_serviceaccount}",
    "system:serviceaccount:${var.namespace}:${var.yatai_image_builder_serviceaccount}"
  ]
}


################################################################################
# ECR
################################################################################

locals {
  create_private_repository = var.repository_type == "private"
  create_public_repository  = var.repository_type == "public"
  #repository_read_access_arns       = [module.assumable_role_yatai.this_iam_role_arn]
  #repository_read_write_access_arns = [module.assumable_role_yatai.this_iam_role_arn]
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

# Policy used by both private and public repositories
data "aws_iam_policy_document" "repository" {
  count = var.use_ecr && var.create_repository_policy ? 1 : 0

  dynamic "statement" {
    for_each = var.repository_type == "public" ? [1] : []

    content {
      sid = "PublicReadOnly"

      principals {
        type = "AWS"
        identifiers = coalescelist(
          [module.assumable_role_yatai.this_iam_role_arn]
          ["*"],
        )
      }

      actions = [
        "ecr-public:BatchGetImage",
        "ecr-public:GetDownloadUrlForLayer",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_type == "private" ? [1] : []

    content {
      sid = "PrivateReadOnly"

      principals {
        type = "AWS"
        identifiers = coalescelist(
          #concat(var.repository_read_access_arns, var.repository_read_write_access_arns),
          [module.assumable_role_yatai.this_iam_role_arn],
          ["arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:root"],
        )
      }

      actions = [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImageScanFindings",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:ListImages",
        "ecr:ListTagsForResource",
      ]
    }
  }


  # TODO: decide if we need the lambda stuff
  #dynamic "statement" {
  #  for_each = var.repository_type == "private" && length(var.repository_lambda_read_access_arns) > 0 ? [1] : []

  #  content {
  #    sid = "PrivateLambdaReadOnly"

  #    principals {
  #      type        = "Service"
  #      identifiers = ["lambda.amazonaws.com"]
  #    }

  #    actions = [
  #      "ecr:BatchGetImage",
  #      "ecr:GetDownloadUrlForLayer",
  #    ]

  #    condition {
  #      test     = "StringLike"
  #      variable = "aws:sourceArn"

  #      values = var.repository_lambda_read_access_arns
  #    }

  #  }
  #}

  dynamic "statement" {
    for_each = var.repository_type == "private" ? [module.assumable_role_yatai.this_iam_role_arn] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.repository_type == "public" ? [module.assumable_role_yatai.this_iam_role_arn] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = statement.value
      }

      actions = [
        "ecr-public:BatchCheckLayerAvailability",
        "ecr-public:CompleteLayerUpload",
        "ecr-public:InitiateLayerUpload",
        "ecr-public:PutImage",
        "ecr-public:UploadLayerPart",
      ]
    }
  }
}

################################################################################
# Repository
################################################################################

resource "aws_ecr_repository" "this" {
  count = var.use_ecr && local.create_private_repository ? 1 : 0

  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
    kms_key         = var.repository_kms_key
  }

  force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

  tags = var.tags
}

################################################################################
# Repository Policy
################################################################################


resource "aws_ecr_repository_policy" "this" {
  count = var.use_ecr && local.create_private_repository && var.attach_repository_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
}


################################################################################
# Lifecycle Policy
################################################################################

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.use_ecr && local.create_private_repository && var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.repository_lifecycle_policy
}

################################################################################
# Public Repository
################################################################################

resource "aws_ecrpublic_repository" "this" {
  count = var.use_ecr && local.create_public_repository ? 1 : 0

  repository_name = var.repository_name

  dynamic "catalog_data" {
    for_each = length(var.public_repository_catalog_data) > 0 ? [var.public_repository_catalog_data] : []

    content {
      about_text        = try(catalog_data.value.about_text, null)
      architectures     = try(catalog_data.value.architectures, null)
      description       = try(catalog_data.value.description, null)
      logo_image_blob   = try(catalog_data.value.logo_image_blob, null)
      operating_systems = try(catalog_data.value.operating_systems, null)
      usage_text        = try(catalog_data.value.usage_text, null)
    }
  }
}

################################################################################
# Public Repository Policy
################################################################################

resource "aws_ecrpublic_repository_policy" "example" {
  count = var.use_ecr && local.create_public_repository ? 1 : 0

  repository_name = aws_ecrpublic_repository.this[0].repository_name
  policy          = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
}


################################################################################
# Registry Policy
################################################################################

resource "aws_ecr_registry_policy" "this" {
  count = var.use_ecr && var.create_registry_policy ? 1 : 0

  policy = var.registry_policy
}

################################################################################
# Registry Pull Through Cache Rule
################################################################################

resource "aws_ecr_pull_through_cache_rule" "this" {
  for_each = { for k, v in var.registry_pull_through_cache_rules : k => v if var.use_ecr }

  ecr_repository_prefix = each.value.ecr_repository_prefix
  upstream_registry_url = each.value.upstream_registry_url
}

################################################################################
# Registry Scanning Configuration
################################################################################

resource "aws_ecr_registry_scanning_configuration" "this" {
  count = var.use_ecr && var.manage_registry_scanning_configuration ? 1 : 0

  scan_type = var.registry_scan_type

  dynamic "rule" {
    for_each = var.registry_scan_rules

    content {
      scan_frequency = rule.value.scan_frequency

      repository_filter {
        filter      = rule.value.filter
        filter_type = try(rule.value.filter_type, "WILDCARD")
      }
    }
  }
}

################################################################################
# Registry Replication Configuration
################################################################################

resource "aws_ecr_replication_configuration" "this" {
  count = var.use_ecr && var.create_registry_replication_configuration ? 1 : 0

  replication_configuration {

    dynamic "rule" {
      for_each = var.registry_replication_rules

      content {
        dynamic "destination" {
          for_each = rule.value.destinations

          content {
            region      = destination.value.region
            registry_id = destination.value.registry_id
          }
        }

        dynamic "repository_filter" {
          for_each = try(rule.value.repository_filters, [])

          content {
            filter      = repository_filter.value.filter
            filter_type = repository_filter.value.filter_type
          }
        }
      }
    }
  }
}
