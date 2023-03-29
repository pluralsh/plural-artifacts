{{- if eq .Provider "azure" }}
global:
  extraEnvFrom:
  - secretRef:
      name: mimir-azure-secret
{{- end }}


datasource:
  clusterTenantHeader:
    value: {{ .Cluster }}
{{ if .Configuration.tempo }}
  tempo:
    enabled: true
{{ end }}

mimir-distributed:
  {{- if eq .Provider "aws" }}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
  {{- end }}
  metaMonitoring:
    serviceMonitor:
      clusterLabel: {{ .Cluster }}
  mimir:
    structuredConfig:
      common:
        storage:
          {{- if eq .Provider "aws" }}
          backend: s3
          s3:
            endpoint: s3.{{ .Region }}.amazonaws.com
            region: {{ .Region }}
          {{- else if eq .Provider "google" }}
          backend: gcs
          gcs:
          {{- else if eq .Provider "azure" }}
          backend: azure
          azure:
            account_name: ${AZURE_STORAGE_ACCOUNT}
            account_key: ${AZURE_STORAGE_KEY}
            endpoint_suffix: blob.core.windows.net
          {{- end }}
      blocks_storage:
        {{- if eq .Provider "aws" }}
        backend: s3
        s3:
          bucket_name: {{ .Values.mimirBlocksBucket }}
        {{- else if eq .Provider "google" }}
        backend: gcs
        gcs:
          bucket_name: {{ .Values.mimirBlocksBucket }}
        {{- else if eq .Provider "azure" }}
        backend: azure
        azure:
          container_name: {{ .Values.mimirBlocksBucket }}
        {{- end }}
      alertmanager_storage:
        {{- if eq .Provider "aws" }}
        backend: s3
        s3:
          bucket_name: {{ .Values.mimirAlertBucket }}
        {{- else if eq .Provider "google" }}
        backend: gcs
        gcs:
          bucket_name: {{ .Values.mimirAlertBucket }}
        {{- else if eq .Provider "azure" }}
        backend: azure
        azure:
          container_name: {{ .Values.mimirAlertBucket }}
        {{- end }}
      ruler_storage:
        {{- if eq .Provider "aws" }}
        backend: s3
        s3:
          bucket_name: {{ .Values.mimirRulerBucket }}
        {{- else if eq .Provider "google" }}
        backend: gcs
        gcs:
          bucket_name: {{ .Values.mimirRulerBucket }}
        {{- else if eq .Provider "azure" }}
        backend: azure
        azure:
          container_name: {{ .Values.mimirRulerBucket }}
        {{- end }}
