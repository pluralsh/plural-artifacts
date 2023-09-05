moved {
  from = module.network
  to = module.network[0]
}

moved {
  from = module.aks
  to = module.aks[0]
}

moved {
  from = azurerm_role_assignment.aks-managed-identity
  to = azurerm_role_assignment.aks-managed-identity[0]
}

moved {
  from = azurerm_role_assignment.aks-network-identity-kubelet
  to = azurerm_role_assignment.aks-network-identity-kubelet[0]
}

moved {
  from = azurerm_role_assignment.aks-vm-contributor
  to = azurerm_role_assignment.aks-vm-contributor[0]
}

moved {
  from = azurerm_role_assignment.aks-node-vm-contributor
  to = azurerm_role_assignment.aks-node-vm-contributor[0]
}

moved {
  from = kubernetes_namespace.bootstrap
  to = kubernetes_namespace.bootstrap[0]
}
