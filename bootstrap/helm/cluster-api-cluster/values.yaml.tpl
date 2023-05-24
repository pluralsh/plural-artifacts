provider: {{ .Provider }}
cluster:
  name: {{ .Cluster }}

  {{ if eq .Provider "aws" }}
  kubernetesVersion: v1.24
  aws:
    region: {{ .Region }}
  {{ end }}

  {{ if eq .Provider "azure" }}
  kubernetesVersion: v1.26.3
  azure:
    clientID: {{ .Context.ClientId }}
    clientSecret: {{ .Context.ClientSecret }}
    tenantID: {{ .Context.TenantId }}
    subscriptionID: {{ .Context.SubscriptionId }}
    location: {{ .Region }}
    resourceGroupName: {{ .Project }}
  {{ end }}

  {{ if eq .Provider "google" }}
  kubernetesVersion: 1.24.13-gke.500
  google:
    project: {{ .Project }}
    region: {{ .Region }}
  {{ end }}