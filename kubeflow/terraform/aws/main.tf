resource "kubernetes_namespace" "kubeflow" {
  metadata {
    name = var.namespace

    labels = {
      "app.kubernetes.io/managed-by" = "plural"
      "istio-injection" = "enabled"
      "app.plural.sh/name" = "kubeflow"
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
    "system:serviceaccount:*:${var.kubeflow_serviceaccount}",
    "system:serviceaccount:*:kubeflow-pod"
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
  bucket = var.pipelines_bucket
  acl    = "private"
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

resource "aws_eks_node_group" "gpu" {
  cluster_name    = data.aws_eks_cluster.cluster.name
  node_group_name = "gpu-main"
  node_role_arn   = aws_iam_role.gpu.arn
  subnet_ids      = data.aws_eks_cluster.cluster.vpc_config[0].subnet_ids
  instance_types = var.gpu_instance_type
  ami_type = "AL2_x86_64_GPU"
  release_version = "1.21.2-20210914"
  capacity_type = "ON_DEMAND"

  scaling_config {
    desired_size = 0
    min_size     = 0
    max_size     = 3
  }

  tags = {
    "k8s.io/cluster-autoscaler/node-template/label/nvidia.com/gpu" = "true"
    "k8s.io/cluster-autoscaler/node-template/taint/dedicated" = "nvidia.com/gpu=true"

  }

  taint {
    key = "GPU"
    value = "true"
    effect = "NO_SCHEDULE"
  }

  depends_on = [
    aws_iam_role_policy_attachment.gpu-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.gpu-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.gpu-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "gpu" {
  name = "eks-node-group-gpu"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "gpu-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.gpu.name
}

resource "aws_iam_role_policy_attachment" "gpu-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.gpu.name
}

resource "aws_iam_role_policy_attachment" "gpu-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.gpu.name
}
