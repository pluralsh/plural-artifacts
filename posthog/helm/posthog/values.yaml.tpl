{{ $redisNamespace := namespace "redis" }}
{{- $kafkaNamespace := namespace "kafka" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
{{- $chPassword := dedupe . "posthog.secrets.clickhousePassword" (randAlphaNum 32) }}
global:
  application:
    links:
    - description: posthog web ui
      url: {{ .Values.hostname }}

secrets:
  clickhousePassword: {{ $chPassword }}

posthog:
  {{- if or (eq .Provider "equinix") (eq .Provider "kind") }}
  cloud: other
  {{- else if eq .Provider "google" }}
  cloud: "gcp"
  {{- else }}
  cloud: {{ .Provider }}
  {{- end }}
  {{- if .Values.notificationEmail }}
  notificationEmail: {{ .Values.notificationEmail }}
  {{- end }}
  externalKafka:
    brokers:
    - kafka-kafka-brokers.{{ $kafkaNamespace }}.svc:9092
  externalRedis:
    host: redis-master.{{ $redisNamespace }}
    password: {{ $redisValues.redis.password }}
  siteUrl: https://{{ .Values.hostname }}
  ingress:
    hostname: {{ .Values.hostname }}

  {{- if .SMTP }}
  email:
    host: {{ .SMTP.Server }}
    port: {{ .SMTP.Port }}
    user: {{ .SMTP.User }}
    password: {{ .SMTP.Password }}
    from_email: {{ .SMTP.Sender }}
  {{- end }}

clickhouse:
  password: {{ $chPassword }}
