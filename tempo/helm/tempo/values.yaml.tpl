{{ $traceShield := and .Configuration (index .Configuration "trace-shield") }}

{{- if eq .Provider "aws" }}
provider: aws
{{- else if eq .Provider "google" }}
provider: google
{{- else if eq .Provider "azure" }}
provider: azure
tempoStorageIdentityId: {{ importValue "Terraform" "tempo_msi_id" }}
tempoStorageIdentityClientId: {{ importValue "Terraform" "tempo_msi_client_id" }}
{{- end }}

datasource:
{{- if $traceShield }}
  traceShield:
    enabled: true
    tempoPublicURL: {{ .Values.hostname }}
{{- else }}
  clusterTenantHeader:
    value: {{ .Cluster }}
    enabled: true
{{- end }}
{{- if .Configuration.loki }}
  loki:
    enabled: true
{{- end }}
{{- if .Configuration.mimir }}
  mimir:
    enabled: true
{{- end }}

tempo-distributed:
  serviceAccount:
    {{- if eq .Provider "google" }}
    create: false
    {{- end }}
    {{- if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-tempo"
    {{- end }}
  {{- if eq .Provider "azure" }}
  ingester:
    podLabels:
      aadpodidbinding: tempo
  distributor:
    podLabels:
      aadpodidbinding: tempo
  compactor:
    podLabels:
      aadpodidbinding: tempo
  querier:
    podLabels:
      aadpodidbinding: tempo
  queryFrontend:
    podLabels:
      aadpodidbinding: tempo
  gateway:
    podLabels:
      aadpodidbinding: tempo
  {{- if .Configuration.mimir }}
  metricsGenerator:
    enabled: true
    {{- if eq .Provider "azure" }}
    podLabels:
      aadpodidbinding: tempo
    {{- end }}
    config:
      storage:
        remote_write:
        - url: http://mimir-nginx.mimir/api/v1/push
          headers:
            X-Scope-OrgID: {{ .Cluster }}
  {{- end }}
  {{- end }}
  storage:
    trace:
      {{- if eq .Provider "aws" }}
      backend: s3
      s3:
        bucket: {{ .Values.tempoBucket }}
        endpoint: s3.amazonaws.com
        region: {{ .Region }}
      {{- else if eq .Provider "aws" }}
      backend: gcs
      gcs:
        bucket_name: {{ .Values.tempoBucket }}
      {{- else if eq .Provider "azure" }}
      backend: azure
      azure:
        container_name: {{ .Values.tempoContainer }}
        storage_account_name: {{ .Context.StorageAccount }}
        user_assigned_id: {{ importValue "Terraform" "tempo_msi_client_id" }}
      {{- end }}
