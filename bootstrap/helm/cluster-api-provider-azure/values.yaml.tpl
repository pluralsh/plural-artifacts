cluster-api-provider-azure:
  managerBootstrapCredentials:
    clientId: {{ .Context.ClientId | quote }}
    clientSecret: {{ .Context.ClientSecret | quote }}
    subscriptionId: {{ .Context.SubscriptionId | quote }}
    tenantId: {{ .Context.TenantId | quote }}
