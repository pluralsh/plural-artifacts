configAwsOrGcp:
  wal_s3_bucket: {{ .Values.wal_bucket }}

{{ if eq .Provider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-postgres"
{{ end }}

{{ if eq .Provider "azure" }}
pod_environment_secret: postgres-s3-secret
{{ end }}
