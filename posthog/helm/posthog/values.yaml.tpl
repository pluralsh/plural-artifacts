{{ $redisNamespace := namespace "redis" }}
{{ $kafkaNamespace := namespace "kafka" }}
{{ $redisValues := .Applications.HelmValues "redis" }}
global:
  application:
    links:
    - description: posthog web ui
      url: {{ .Values.hostname }}

{{ $chPassword := dedupe . "posthog.secrets.clickhousePassword" (randAlphaNum 32) }}

secrets:
  clickhousePassword: {{ $chPassword }}

posthog:
  {{ if or (eq .Provider "equinix") (eq .Provider "kind") }}
  cloud: other
  {{- else if eq .Provider "google" }}
  cloud: "gcp"
  {{- else }}
  cloud: {{ .Provider }}
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

clickhouse:
  password: {{ $chPassword }}
