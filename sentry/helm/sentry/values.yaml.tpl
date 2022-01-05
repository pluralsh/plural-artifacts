global:
  application:
    links:
    - description: sentry web ui
      url: {{ .Values.hostname }}

{{ if eq .Provider "google" }}
postgresNamespace: {{ namespace "postgres" }}
{{ end }}

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
  {{ if eq .Provider "azure" }}
    backend: s3
    s3:
      bucketName: {{ .Values.filestoreBucket }}
      region_name: "us-east-1"
      {{ $sentryNamespace := namespace "sentry" }}
      {{ $sentryCreds := secret $sentryNamespace "sentry-s3-secret" }}
      accessKey: {{ $sentryCreds.AWS_ACCESS_KEY_ID }}
      secretKey: {{ $sentryCreds.AWS_SECRET_ACCESS_KEY }}
      endpointUrl: {{ printf "https://%s" .Configuration.minio.hostname }}
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

  {{ if .SMTP }}
  mail:
    backend: smtp
    username: {{ .SMTP.User }}
    password: {{ .SMTP.Password }}
    host: {{ .SMTP.Server }}
    port: {{ .SMTP.Port }}
    from: {{ .SMTP.Sender }}
  {{ end }}

  serviceAccount:
    {{ if eq .Provider "google" }}
    create: false
    {{ else if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-sentry"
    {{ else }}
    annotations: {}
    {{ end }}

  {{ $rabbitNamespace := namespace "rabbitmq" }}
  {{ $creds := secret $rabbitNamespace "rabbitmq-default-user" }}
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

  {{ $kafkaNamespace := namespace "kafka" }}
  externalKafka:
    host: kafka-kafka-bootstrap.{{ $kafkaNamespace }}

  user:
    email: {{ .Values.adminEmail }}
    password: {{ dedupe . "sentry.sentry.user.password" (randAlphaNum 20) }}

  postgresql:
    postgresqlPassword: {{ dedupe . "sentry.sentry.postgresql.postgresqlPassword" (randAlphaNum 14) }}
    postgresqlPostgresPassword: {{ dedupe . "sentry.sentry.postgresql.postgresqlPostgresPassword" (randAlphaNum 14) }}
