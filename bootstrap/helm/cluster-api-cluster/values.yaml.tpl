provider: {{ .Provider }}
cluster:
  name: {{ .Cluster }}

  {{ if eq .Provider "aws" }}
  kubernetesVersion: v1.24
  aws:
    region: {{ .Region }}
    iamAuthenticatorConfig:
      mapRoles:
      - rolearn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-capa-controller"
        username: capa-admin
        groups:
        - system:masters
  {{ end }}

  {{ if eq .Provider "azure" }}
  kubernetesVersion: v1.24.10
  azure:
    clientID: {{ .Context.ClientId }}
    clientSecret: {{ .Context.ClientSecret }}
    tenantID: {{ .Context.TenantId }}
    subscriptionID: {{ .Context.SubscriptionId }}
    location: {{ .Region }}
    resourceGroupName: {{ .Project }}
    virtualNetwork:
      name: {{ .Values.network_name | quote }}
  {{ end }}

  {{ if eq .Provider "google" }}
  kubernetesVersion: 1.24.14-gke.2700
  google:
    project: {{ .Project }}
    region: {{ .Region }}
  {{ end }}

  {{ if eq .Provider "kind" }}
  kubernetesVersion: v1.27.3
  serviceCidrBlocks:
    - 10.128.0.0/12
  {{ end }}