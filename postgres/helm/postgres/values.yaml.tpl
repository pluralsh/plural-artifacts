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
configSecret:
  AWS_SDK_LOAD_CONFIG: "1"
  USE_WALG_BACKUP: "true"
  USE_WALG_RESTORE: "true"
  AWS_S3_FORCE_PATH_STYLE: "true"
  AWS_ENDPOINT: {{ .Configuration.minio.hostname }}
  AWS_ACCESS_KEY_ID: {{ importValue "Terraform" "access_key_id" }}
  AWS_SECRET_ACCESS_KEY: {{ importValue "Terraform" "secret_access_key" }}
{{ end }}
