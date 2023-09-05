enabled: {{ not .ClusterAPI }}
aad-pod-identity:
  adminsecret:
    cloud: AzurePublicCloud
    subscriptionID: {{ .Context.SubscriptionId }}
    resourceGroup: {{ importValue "Terraform" "node_resource_group" }}
    tenantID: {{ .Context.TenantId }}
    vmType: vmss
    clientID: msi
    clientSecret: msi
    useMSI: 'true'
    userAssignedMSIClientID: {{ importValue "Terraform" "kubelet_msi_id" }}