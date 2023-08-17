aad-pod-identity:
  {{ if chartInstalled "cluster-api-provider-azure" "bootstrap" }}
  enabled: false
  {{ end }}
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