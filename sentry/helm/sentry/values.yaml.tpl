sentry:
  system:
    secretKey: {{ dedupe . "sentry.sentry.system.secretKey" (randAlphaNum 16) }}
  symbolicator:
    enabled: true
  ingress:
    hostname: {{ .Values.hostname }}
    tls:
    - secretName: sentry-tls
      hosts:
      - {{ .Values.hostname }}
  filestore:
  {{ if eq .Provider "google" }}
    backend: gcs
    gcs:
      bucketName: {{ .Values.filestoreBucket }}
  {{ end }}
  {{ if eq .Provider "aws" }}
    backend: s3
    s3:
      bucketName: {{ .Values.filestoreBucket }}
      region_name: {{ .Region }}
  {{ end }}

  {{ if .OIDC }}
  config:
    sentryConfPy: |-
      OIDC_CLIENT_ID = "{{ .OIDC.ClientId }}"
      OIDC_CLIENT_SECRET = "{{ .OIDC.ClientSecret }}"
      OIDC_SCOPE = "openid"
      OIDC_DOMAIN = "{{ .OIDC.Configuration.Issuer }}"
  {{ end }}

  serviceAccount:
    {{ if eq .Provider "google" }}
    create: false
    {{ end }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-sentry"

  {{ $rabbitNamespace := namespace "rabbitmq" }}
  {{ $creds := dedupeObj . "sentry.sentry.rabbitmq.auth" (secret $rabbitNamespace "rabbitmq-default-user") }}
  rabbitmq:
    host: rabbitmq.{{ $rabbitNamespace }}
    auth:
      username: {{ $creds.username }}
      password: {{ $creds.password }}
  
  {{ $redisNamespace := namespace "redis" }}
  {{ $creds := secret $redisNamespace "redis-password" }}
  externalRedis:
    host: redis-master.{{ $redisNamespace }}
    password: {{ $creds.password | quote }}

  user:
    email: {{ .Values.adminEmail }}
    password: {{ dedupe . "sentry.sentry.user.password" (randAlphaNum 20) }}

  postgresql:
    postgresqlPassword: {{ dedupe . "sentry.sentry.postgresql.postgresqlPassword" (randAlphaNum 14) }}
    postgresqlPostgresPassword: {{ dedupe . "sentry.sentry.postgresql.postgresqlPostgresPassword" (randAlphaNum 14) }}