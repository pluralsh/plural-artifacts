mimir-distributed:
  {{- if eq .Provider "aws" }}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
  {{- end }}
  mimir:
    structuredConfig:
      common:
        storage:
          {{- if eq .Provider "aws" }}
          backend: s3
          s3:
            s3: s3://{{ .Region }}
            region: {{ .Region }}
          {{- else if eq .Provider "google" }}
          backend: gcs
          gcs:
          {{- else if eq .Provider "azure" }}
          backend: azure
          azure:
            environment: AzureGlobal
            account_name: ${AZURE_STORAGE_ACCOUNT}
            account_key: ${AZURE_STORAGE_KEY}
          {{- end }}
      blocks_storage:
        {{- if eq .Provider "aws" }}
        s3:
          bucket_name: {{ .Values.mimirBlocksBucket }}
        {{- end }}

      alertmanager_storage:
        {{- if eq .Provider "aws" }}
        s3:
          bucket_name: {{ .Values.mimirAlertBucket }}
        {{- end }}

      ruler_storage:
        {{- if eq .Provider "aws" }}
        s3:
          bucket_name: {{ .Values.mimirRulerBucket }}
        {{- end }}
