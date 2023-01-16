{{- $redisNamespace := namespace "redis" }}
{{ $redisValues := .Applications.HelmValues "redis" }}
global:
  application:
    links:
    - description: chatwoot web ui
      url: {{ .Values.hostname }}

chatwoot:
  serviceAccount:
    {{- if eq .Provider "google" }}
    create: false
    {{- end }}
    name: chatwoot
    {{- if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-chatwoot"
    {{- end }}
  redis:
    host: redis-master.{{ $redisNamespace }}
    password: {{ $redisValues.redis.password }}
  ingress:
    hosts:
      - host: {{ .Values.hostname }}
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: chatwoot
                port:
                  number: 3000
    tls:
     - secretName: chatwoot-tls-certificate
       hosts:
         - {{ .Values.hostname }}
  env:
    FRONTEND_URL: "https://{{ .Values.hostname }}"
    SECRET_KEY_BASE: {{ dedupe . "chatwoot.chatwoot.env.SECRET_KEY_BASE" (randAlphaNum 32) }}
    {{- if eq .Provider "aws" }}
    ACTIVE_STORAGE_SERVICE: amazon
    S3_BUCKET_NAME: {{ .Values.chatwootBucket }}
    AWS_REGION: {{ .Region }}
    {{- else if eq .Provider "google" }}
    ACTIVE_STORAGE_SERVICE: google
    GCS_PROJECT: {{ .Project }}
    GCS_BUCKET: {{ .Values.chatwootBucket }}
    {{- else if eq .Provider "azure" }}
    ACTIVE_STORAGE_SERVICE: microsoft
    AZURE_STORAGE_ACCOUNT_NAME: {{ .Context.StorageAccount }}
    AZURE_STORAGE_CONTAINER: {{ .Values.chatwootContainer }}
    {{- end }}
    {{ if .SMTP }}
    SMTP_ADDRESS: {{ .SMTP.Server }}
    SMTP_AUTHENTICATION: plain
    SMTP_ENABLE_STARTTLS_AUTO: 'true'
    SMTP_USERNAME: {{ .SMTP.User }}
    SMTP_PASSWORD: {{ .SMTP.Password }}
    SMTP_PORT: {{ .SMTP.Port }}
    MAILER_SENDER_EMAIL: {{ .SMTP.Sender }}
    {{ end }}
