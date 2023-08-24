provider: {{ .Provider }}
cluster:
  name: {{ .Cluster }}

  {{ if eq .Provider "aws" }}
  kubernetesVersion: v1.24
  aws:
    region: {{ .Region }}
    {{ if .AvailabilityZones }}
    availabilityZones: {{ toYaml .AvailabilityZones | nindent 6 }}
    {{ end }}
    iamAuthenticatorConfig:
      mapRoles:
      - rolearn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-capa-controller"
        username: capa-admin
        groups:
        - system:masters
  {{ end }}

  {{ if eq .Provider "azure" }}
  kubernetesVersion: v1.25.11
  azure:
    clusterIdentity:
      {{- if and .Context.ClientId .Context.ClientSecret }}
      bootstrapCredentials:
        clientID: {{ .Context.ClientId }}
        clientSecret: {{ .Context.ClientSecret }}
      {{- end }}
      workloadIdentity:
        clientID: {{ importValue "Terraform" "capz_assigned_identity_client_id" }}
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
    network:
      name: {{ .Values.vpc_name | quote }}
  {{ end }}

  {{ if eq .Provider "kind" }}
  kubernetesVersion: v1.23.13
  serviceCidrBlocks:
    - 10.128.0.0/12
  {{ end }}