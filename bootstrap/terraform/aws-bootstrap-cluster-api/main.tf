provider "aws" {
 region = var.aws_region
}

data "aws_eks_cluster" "cluster" {
 name = var.cluster_name
}