configAwsOrGcp:
{{ if eq .Provider "aws" }}
  wal_s3_bucket: {{ .Values.wal_bucket }}
{{ else if eq .Provider "google" }}
  additional_secret_mount: postgres-gcp-creds
  additional_secret_mount_path: "/var/secrets/google"

  wal_gs_bucket: {{ .Values.wal_bucket }}
  gcp_credentials: "/var/secrets/google/credentials.json"
{{ end }}

{{ if eq .Provider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-postgres"
{{ end }}

{{ if eq .Provider "azure" }}

{{ $postgresNamespace := namespace "postgres" }}
{{ $minioHostname := .Configuration.minio.hostname }}
{{ $creds := secret $postgresNamespace "postgres-s3-secret" }}

configSecret:
  AWS_SDK_LOAD_CONFIG: "1"
  USE_WALG_BACKUP: "true"
  USE_WALG_RESTORE: "true"
  AWS_S3_FORCE_PATH_STYLE: "true"
  AWS_ENDPOINT: {{ $minioHostname }}
  AWS_ACCESS_KEY_ID: {{ $creds.AWS_ACCESS_KEY_ID }}
  AWS_SECRET_ACCESS_KEY: {{ $creds.AWS_SECRET_ACCESS_KEY }}
{{ end }}
