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
  force_destroy = true
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

resource "aws_eks_node_group" "gpu_inf_small" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-gpu-inf-small"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_gpu_inf_small
  ami_type = "AL2_x86_64_GPU"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 3
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu" = "true"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "ON_DEMAND"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/scalingGroup" = "GPU-Inf-Small"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-gpux"
    # "k8s.io/cluster-autoscaler/node-template/taint/instance" = "DL-gpux:NoSchedule"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "nvidia.com/gpu=true"

  }

  labels = {
    "plural.sh/capacityType" = "ON_DEMAND"
    "plural.sh/scalingGroup" = "GPU-Inf-Small"
    "nvidia.com/gpu" = "true"
  }

  taint {
    key = "nvidia.com/gpu"
    value = "true"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "gpu_inf_small_spot" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-gpu-inf-small-spot"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_gpu_inf_small
  ami_type = "AL2_x86_64_GPU"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "SPOT"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 3
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu" = "true"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "SPOT"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/scalingGroup" = "GPU-Inf-Small"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-spot-gpux"
    # "k8s.io/cluster-autoscaler/node-template/taint/instance" = "DL-spot-gpux:NoSchedule"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "nvidia.com/gpu=true"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "plural.sh/capacityType=SPOT"

  }

  labels = {
    "plural.sh/capacityType" = "SPOT"
    "plural.sh/scalingGroup" = "GPU-Inf-Small"
    "nvidia.com/gpu" = "true"
  }

  taint {
    key = "nvidia.com/gpu"
    value = "true"
    effect = "NO_SCHEDULE"
  }

  taint {
    key = "plural.sh/capacityType"
    value = "SPOT"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "gpu_small" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-gpu-small"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_gpu_small
  ami_type = "AL2_x86_64_GPU"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 3
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu" = "true"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "ON_DEMAND"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/scalingGroup" = "GPU-Small"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-gpux"
    # "k8s.io/cluster-autoscaler/node-template/taint/instance" = "DL-gpux:NoSchedule"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "nvidia.com/gpu=true"

  }

  labels = {
    "plural.sh/capacityType" = "ON_DEMAND"
    "plural.sh/scalingGroup" = "GPU-Small"
    "nvidia.com/gpu" = "true"
  }

  taint {
    key = "nvidia.com/gpu"
    value = "true"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "gpu_small_spot" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-gpu-small-spot"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_gpu_small
  ami_type = "AL2_x86_64_GPU"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "SPOT"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 3
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu" = "true"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "SPOT"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/scalingGroup" = "GPU-Small"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-spot-gpux"
    # "k8s.io/cluster-autoscaler/node-template/taint/instance" = "DL-spot-gpux:NoSchedule"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "nvidia.com/gpu=true"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "plural.sh/capacityType=SPOT"

  }

  labels = {
    "plural.sh/capacityType" = "SPOT"
    "plural.sh/scalingGroup" = "GPU-Small"
    "nvidia.com/gpu" = "true"
  }

  taint {
    key = "nvidia.com/gpu"
    value = "true"
    effect = "NO_SCHEDULE"
  }

  taint {
    key = "plural.sh/capacityType"
    value = "SPOT"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "gpu_medium" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-gpu-medium"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_gpu_medium
  ami_type = "AL2_x86_64_GPU"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 3
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu" = "true"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "ON_DEMAND"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/scalingGroup" = "GPU-Medium"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-gpux"
    # "k8s.io/cluster-autoscaler/node-template/taint/instance" = "DL-gpux:NoSchedule"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "nvidia.com/gpu=true"

  }

  labels = {
    "plural.sh/capacityType" = "ON_DEMAND"
    "plural.sh/scalingGroup" = "GPU-Medium"
    "nvidia.com/gpu" = "true"
  }

  taint {
    key = "nvidia.com/gpu"
    value = "true"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "gpu_medium_spot" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-gpu-medium-spot"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_gpu_medium
  ami_type = "AL2_x86_64_GPU"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "SPOT"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 3
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu" = "true"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "SPOT"
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/scalingGroup" = "GPU-Medium"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-spot-gpux"
    # "k8s.io/cluster-autoscaler/node-template/taint/instance" = "DL-spot-gpux:NoSchedule"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "nvidia.com/gpu=true"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "plural.sh/capacityType=SPOT"

  }

  labels = {
    "plural.sh/capacityType" = "SPOT"
    "plural.sh/scalingGroup" = "GPU-Medium"
    "nvidia.com/gpu" = "true"
  }

  taint {
    key = "nvidia.com/gpu"
    value = "true"
    effect = "NO_SCHEDULE"
  }

  taint {
    key = "plural.sh/capacityType"
    value = "SPOT"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "spot_small" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-small-spot"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_small
  ami_type = "AL2_x86_64"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "SPOT"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 5
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "SPOT"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-spot"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "plural.sh/capacityType=SPOT"

  }

  labels = {
    "plural.sh/capacityType" = "SPOT"
  }

  taint {
    key = "plural.sh/capacityType"
    value = "SPOT"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "spot_medium" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-medium-spot"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_medium
  ami_type = "AL2_x86_64"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "SPOT"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 5
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "SPOT"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-spot"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "plural.sh/capacityType=SPOT"

  }

  labels = {
    "plural.sh/capacityType" = "SPOT"
  }

  taint {
    key = "plural.sh/capacityType"
    value = "SPOT"
    effect = "NO_SCHEDULE"
  }
}

resource "aws_eks_node_group" "spot_large" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "${var.cluster_name}-large-spot"
  node_role_arn   = data.aws_eks_node_group.main.node_role_arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.instance_types_large
  ami_type = "AL2_x86_64"
  release_version = var.ami_release_version
  disk_size = 50
  capacity_type = "SPOT"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 5
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/plural.sh/capacityType" = "SPOT"
    # "k8s.io/cluster-autoscaler/node-template/label/instance" = "DL-spot"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "plural.sh/capacityType=SPOT"

  }

  labels = {
    "plural.sh/capacityType" = "SPOT"
  }

  taint {
    key = "plural.sh/capacityType"
    value = "SPOT"
    effect = "NO_SCHEDULE"
  }
}
