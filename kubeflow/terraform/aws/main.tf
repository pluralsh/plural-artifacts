resource "kubernetes_namespace" "kubeflow" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "app.plural.sh/name" = "kubeflow"
      "istio-injection" = "enabled"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.cluster_name
}

module "assumable_role_kubeflow" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "3.14.0"
  create_role                   = true
  role_name                     = "${var.cluster_name}-${var.role_name}"
  provider_url                  = replace(data.aws_eks_cluster.cluster.identity[0].oidc[0].issuer, "https://", "")
  role_policy_arns              = [aws_iam_policy.kubeflow.arn]
  oidc_subjects_with_wildcards = [
    "system:serviceaccount:*:${var.kubeflow_argo_serviceaccount}"
  ]
}

resource "aws_iam_access_key" "pipelines" {
  user    = aws_iam_user.pipelines.name
}

# create iam user(s) with full s3 permissions
resource "aws_iam_user" "pipelines" {
  name          = "pipelines-${var.cluster_name}"
  force_destroy = true
}

resource "aws_iam_user_policy_attachment" "attach_s3_full_access" {
  user       = aws_iam_user.pipelines.name
  policy_arn = aws_iam_policy.kubeflow.arn
}

resource "aws_iam_policy" "kubeflow" {
  name_prefix = "kubeflow"
  description = "policy for kubeflow operator resources"
  policy      = data.aws_iam_policy_document.kubeflow.json
}

resource "kubernetes_secret" "pipelines_s3_secret" {
  metadata {
    name = "pipelines-s3-secret"
    namespace = kubernetes_namespace.kubeflow.id
  }
  data = {
    "username" = aws_iam_access_key.pipelines.id
    "password" = aws_iam_access_key.pipelines.secret
  }
}

resource "aws_s3_bucket" "pipelines" {
  bucket        = var.pipelines_bucket
  acl           = "private"
  force_destroy = var.force_destroy_pipelines_bucket

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }
}

data "aws_iam_policy_document" "kubeflow" {
  statement {
    sid    = "admin"
    effect = "Allow"
    actions = ["s3:*"]

    resources = [
      "arn:aws:s3:::${var.pipelines_bucket}",
      "arn:aws:s3:::${var.pipelines_bucket}/*"
    ]
  }
}

data "aws_eks_node_groups" "cluster" {
  cluster_name    = var.cluster_name
}

data "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = tolist(data.aws_eks_node_groups.cluster.names)[0]
}

module "node_groups" {
  source                 = "github.com/pluralsh/module-library//terraform/eks-node-groups/single-az-node-groups?ref=20e64863ffc5e361045db8e6b81b9d244a55809e"
  cluster_name           = var.cluster_name
  default_iam_role_arn   = data.aws_eks_node_group.main.node_role_arn
  tags                   = var.tags
  node_groups_defaults   = var.node_groups_defaults

  node_groups            = var.single_az_node_groups
  set_desired_size       = false
  private_subnets        = data.aws_eks_node_group.main.subnet_idss
}
