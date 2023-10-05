cluster-api-provider-azure:
  asoControllerSettings:
    azureSubscriptionId: {{ .Context.SubscriptionId }}
    azureTenantId: {{ .Context.TenantId }}
    azureClientId: {{ importValue "Terraform" "capz_assigned_identity_client_id" }}