moved {
  from = module.vpc
  to   = module.vpc[0]
}

moved {
  from = module.single_az_node_groups
  to   = module.single_az_node_groups[0]
}

moved {
  from = module.multi_az_node_groups
  to   = module.multi_az_node_groups[0]
}

moved {
  from = aws_eks_addon.vpc_cni
  to   = aws_eks_addon.vpc_cni[0]
}

moved {
  from = aws_eks_addon.core_dns
  to   = aws_eks_addon.core_dns[0]
}

moved {
  from = aws_eks_addon.kube_proxy
  to   = aws_eks_addon.kube_proxy[0]
}

moved {
  from = kubernetes_namespace.bootstrap
  to   = kubernetes_namespace.bootstrap[0]
}
