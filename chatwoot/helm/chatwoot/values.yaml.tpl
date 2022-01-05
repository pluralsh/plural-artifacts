{{- $redisNamespace := namespace "redis" }}
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
    host: redis-master.{{ $redisNamespace }}:6379
    password: {{ .Applications.redis.password }}
    port: 6379
  ingress:
    enabled: true
    annotations:
      cert-manager.io/cluster-issuer: letsencrypt-prod
      kubernetes.io/ingress.class: nginx
      kubernetes.io/tls-acme: "true"
      nginx.ingress.kubernetes.io/ssl-passthrough: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    hosts:
      - host: {{ .Values.hostname }}
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: chatwoot
                port:
                  number: 80
    tls:
     - secretName: chatwoot-tls-certificate
       hosts:
         - {{ .Values.hostname }}
  env:
    FRONTEND_URL: "https://{{ .Values.hostname }}"
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
