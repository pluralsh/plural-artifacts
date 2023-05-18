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

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "s3_buckets" {
  source        = "github.com/pluralsh/module-library//terraform/s3-buckets?ref=bucket-protection"
  bucket_names  = [var.bucket]
  policy_prefix = "yatai"
  force_destroy = var.force_destroy_bucket
}


# use one role for both ECR and S3 access policies
module "assumable_role_yatai" {
  source           = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version          = "3.14.0"
  create_role      = true
  role_name        = "${var.cluster_name}-${var.role_name}"
  provider_url     = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns = [module.s3_buckets.policy_arn, aws_iam_policy.ecr_get_authorization_token.arn]
  oidc_fully_qualified_subjects = [
    "system:serviceaccount:${var.namespace}:${var.yatai_serviceaccount}",
    "system:serviceaccount:${var.namespace}:${var.yatai_deployment_serviceaccount}",
    "system:serviceaccount:${var.namespace}:${var.yatai_image_builder_serviceaccount}",
    "system:serviceaccount:${var.namespace}:default"
  ]
}

resource "kubernetes_default_service_account" "default" {
  metadata {
    namespace = var.namespace

    annotations = {
      "eks.amazonaws.com/role-arn" = module.assumable_role_yatai.this_iam_role_arn
    }
  }

  depends_on = [module.assumable_role_yatai, kubernetes_namespace.yatai]
}


################################################################################
# ECR
################################################################################

locals {
  create_private_repository = var.repository_type == "private"
  create_public_repository  = var.repository_type == "public"
}

data "aws_caller_identity" "current" {}
data "aws_partition" "current" {}

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
  dynamic "statement" {
    for_each = var.repository_type == "private" ? [module.assumable_role_yatai.this_iam_role_arn] : []

    content {
      sid = "ReadWrite"

      principals {
        type        = "AWS"
        identifiers = [statement.value]
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
        identifiers = [statement.value]
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

data "aws_iam_policy_document" "ecr_get_authorization_token" {
  statement {
    sid       = "ExplicitSelfRoleAssumption"
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ecr_get_authorization_token" {
  name   = "yatai-ecr-get-authorization-token"
  policy = data.aws_iam_policy_document.ecr_get_authorization_token.json
}

resource "aws_ecr_repository" "this" {
  count = var.use_ecr && local.create_private_repository ? 1 : 0

  name                 = var.repository_name
  image_tag_mutability = var.repository_image_tag_mutability

  encryption_configuration {
    encryption_type = var.repository_encryption_type
    kms_key         = var.repository_kms_key
  }

  # TODO: not supported by tf provider 3.63
  #force_delete = var.repository_force_delete

  image_scanning_configuration {
    scan_on_push = var.repository_image_scan_on_push
  }

}

resource "aws_ecr_repository_policy" "this" {
  count      = var.use_ecr && local.create_private_repository && var.attach_repository_policy ? 1 : 0
  repository = aws_ecr_repository.this[0].name
  policy     = var.create_repository_policy ? data.aws_iam_policy_document.repository[0].json : var.repository_policy
}

resource "aws_ecr_lifecycle_policy" "this" {
  count = var.use_ecr && local.create_private_repository && var.create_lifecycle_policy ? 1 : 0

  repository = aws_ecr_repository.this[0].name
  policy     = var.repository_lifecycle_policy
}

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

resource "aws_ecr_registry_policy" "this" {
  count = var.use_ecr && var.create_registry_policy ? 1 : 0

  policy = var.registry_policy
}
