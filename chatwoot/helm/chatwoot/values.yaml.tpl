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
  postgresql:
    enabled: false
    postgresqlHost: chatwoot-postgres-master
    postgresqlPort: 5432
    postgresqlDatabase: chatwoot
    postgresqlUsername: chatwoot
    existingSecret: chatwoot.plural-postgres-chatwoot.credentials.postgresql.acid.zalan.do
    existingSecretKey: password
  redis:
    enabled: false
    host: redis-master.{{ $redisNamespace }}
    password: {{ $redisValues.redis.password }}
    port: 6379
  ingress:
    enabled: true
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      kubernetes.io/ingress.class: nginx
      kubernetes.io/tls-acme: "true"
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
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
