configAwsOrGcp:
{{ if or (eq .Provider "aws") (eq .Provider "azure") (eq .Provider "equinix") (eq .Provider "kind") }}
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

provider: {{ .Provider }}

configConfigMap:
  AWS_SDK_LOAD_CONFIG: "1"
  USE_WALG_BACKUP: "true"
  USE_WALG_RESTORE: "true"
  CLONE_USE_WALG_RESTORE: "true"
  {{- if eq .Provider "azure" }}
  AWS_S3_FORCE_PATH_STYLE: "true"
  AWS_ENDPOINT: {{ .Configuration.minio.hostname }}
  {{- end }}
  {{- if eq .Provider "equinix" }}
  AWS_S3_FORCE_PATH_STYLE: "true"
  AWS_ENDPOINT: {{ .Configuration.minio.hostname }}
  {{- end }}
  {{- if eq .Provider "kind" }}
  AWS_S3_FORCE_PATH_STYLE: "true"
  AWS_ENDPOINT: {{ .Configuration.minio.hostname }}
  {{- end }}

{{ if or (eq .Provider "azure") (eq .Provider "equinix") (eq .Provider "kind") }}
configKubernetes:
  pod_environment_secret: plural-postgres-s3
{{ end }}

{{ if or (eq .Provider "azure") (eq .Provider "equinix") (eq .Provider "kind") }}
configSecret:
  enabled: true
  env:
    AWS_ACCESS_KEY_ID: {{ importValue "Terraform" "access_key_id" }}
    AWS_SECRET_ACCESS_KEY: {{ importValue "Terraform" "secret_access_key" }}
{{ end }}
