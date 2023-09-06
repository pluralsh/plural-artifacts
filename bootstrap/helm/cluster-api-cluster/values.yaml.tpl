{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
enabled: {{ .ClusterAPI }}
{{- if $isGcp }}
provider: gcp
{{- else }}
provider: {{ .Provider }}
{{- end }}
cluster:
  name: {{ .Cluster }}

  {{- if eq .Provider "aws" }}
  aws:
    region: {{ .Region }}
    iamAuthenticatorConfig:
      mapRoles:
      - rolearn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-capa-controller"
        username: capa-admin
        groups:
        - system:masters
    {{- if .AvailabilityZones }}
    network:
      vpc:
        availabilityZoneUsageLimit: {{ len .AvailabilityZones }}
    {{- end }}
  {{- end }}

  {{- if eq .Provider "azure" }}
  azure:
    clusterIdentity:
      workloadIdentity:
        clientID: {{ importValue "Terraform" "capz_assigned_identity_client_id" }}
      tenantID: {{ .Context.TenantId }}
    subscriptionID: {{ .Context.SubscriptionId }}
    location: {{ .Region }}
    resourceGroupName: {{ .Project }}
    virtualNetwork:
      name: {{ .Values.network_name | quote }}
  {{- end }}

  {{- if $isGcp }}
  gcp:
    project: {{ .Project }}
    region: {{ .Region }}
    network:
      name: {{ .Values.vpc_name | quote }}
  {{- end }}

  {{- if eq .Provider "kind" }}
  serviceCidrBlocks:
    - 10.128.0.0/12
  {{- end }}

{{- if eq .Provider "aws" }}
workers:
  defaults:
    aws:
      spec:
        {{- if .AvailabilityZones }}
        availabilityZones: {{ toYaml .AvailabilityZones | nindent 8 }}
        {{- end }}
{{- end }}
