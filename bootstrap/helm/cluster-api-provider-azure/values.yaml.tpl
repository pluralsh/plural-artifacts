cluster-api-provider-azure:
  asoControllerSettings:
    azureSubscriptionId: {{ .Context.SubscriptionId }}
    azureTenantId: {{ .Context.TenantId }}
    azureClientId: {{ importValue "Terraform" "aso_assigned_identity_client_id" }}