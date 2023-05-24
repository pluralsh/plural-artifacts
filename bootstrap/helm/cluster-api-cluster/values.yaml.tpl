provider: {{ .Provider }}
cluster:
  name: {{ .Cluster }}
  {{ if eq .Provider "aws" }}
  kubernetesVersion: v1.24
  {{ end }}
  {{ if eq .Provider "azure" }}
  kubernetesVersion: v1.26.3
  {{ end }}
  aws:
    region: {{ .Region }}
  azure:
    clientID: {{ .Context.ClientId }}
    clientSecret: {{ .Context.ClientSecret }}
    tenantID: {{ .Context.TenantId }}
    subscriptionID: {{ .Context.SubscriptionId }}
    location: {{ .Region }}
    resourceGroupName: {{ .Project }}
