global:
  application:
    links:
    - description: sentry web ui
      url: {{ .Values.hostname }}

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
      accessKey: {{ importValue "Terraform" "access_key_id" }}
      secretKey: {{ importValue "Terraform" "secret_access_key" }}
      endpointUrl: https://{{ .Configuration.minio.hostname }}
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

  rabbitmq:
    host: rabbitmq.{{ namespace "rabbitmq" }}
    auth:
      username: {{ importValue "Terraform" "rabbitmq_username" }}
      password: {{ importValue "Terraform" "rabbitmq_password" }}

  externalRedis:
    host: redis-master.{{ namespace "redis" }}
    password: {{ importValue "Terraform" "redis_password" }}

  {{ $kafkaNamespace := namespace "kafka" }}
  externalKafka:
    host: kafka-kafka-bootstrap.{{ $kafkaNamespace }}

  user:
    email: {{ .Values.adminEmail }}
    password: {{ dedupe . "sentry.sentry.user.password" (randAlphaNum 20) }}
