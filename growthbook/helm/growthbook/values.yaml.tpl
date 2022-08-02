global:
  application:
    links:
    - description: growthbook web ui
      url: https://{{ .Values.hostname }}
    - description: growthbook api
      url: https://{{ .Values.apiHostname }}

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-argo-workflows"
    {{ if eq .Provider "google" }}
    iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
    {{ end }}

mongoNamespace: {{ namespace "mongodb" }}

ingress:
  tls:
  - secretName: growthbook-tls
    hosts:
    - {{ .Values.hostname }}
    - {{ .Values.apiHostname }}
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: /.*
      pathType: ImplementationSpecific
      port: http
  - host: {{ .Values.apiHostname }}
    paths:
    - path: /.*
      pathType: ImplementationSpecific
      port: api

{{ if .SMTP }}
email:
  ENABLED: 'true'
  HOST: {{ .SMTP.Server }}
  PORT: {{ .SMTP.Port }}
  HOST_USER: {{ .SMTP.User }}
  HOST_PASSWORD: {{ .SMTP.Password }}
  FROM: {{ .SMTP.Sender }}
{{ end }}

env:
  origin: https://{{ .Values.hostname }}
  apiHost: https://{{ .Values.apiHostname }}
  jwtSecret: {{ dedupe . "growthbook.env.jwtSecret" (randAlphaNum 16) }}
  encryptionKey: {{ dedupe . "growthbook.env.encryptionKey" (randAlphaNum 16) }}
{{ if eq .Provider "aws" }}
  rest:
    UPLOAD_METHOD: s3
    S3_BUCKET: {{ .Values.growthbookBucket }}
    S3_REGION: {{ .Region }}
{{ end }}
{{ if eq .Provider "gcp" }}
  rest:
    UPLOAD_METHOD: google-cloud
    GCS_BUCKET_NAME: {{ .Values.growthbookBucket }}
{{ end }}
{{ if eq .Provder "azure" }}
  rest:
    UPLOAD_METHOD: s3
    S3_BUCKET: {{ .Values.growthbookBucket }}
    S3_DOMAIN: https://{{ .Configuration.minio.hostname | quote }}
    AWS_ACCESS_KEY_ID: {{ importValue "Terraform" "access_key_id" }}
    AWS_SECRET_ACCESS_KEY: {{ importValue "Terraform" "secret_access_key" }}
{{ end }}