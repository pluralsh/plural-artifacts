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
  {{- if .Values.slack.enabled }}
  slack:
    enabled: true
    clientID: {{ .Values.slack.clientID | quote }}
    clientSecret: {{ .Values.slack.clientSecret | quote }}
    signingSecret: {{ .Values.slack.signingSecret | quote }}
  {{- end }}

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

  {{- if .Values.slack.enabled }}
  env:
  - name: SLACK_APP_CLIENT_ID
    valueFrom:
      secretKeyRef:
        name: plural-posthog-slack-secret
        key: clientID
  - name: SLACK_APP_CLIENT_SECRET
    valueFrom:
      secretKeyRef:
        name: plural-posthog-slack-secret
        key: clientSecret
  - name: SLACK_APP_SIGNING_SECRET
    valueFrom:
      secretKeyRef:
        name: plural-posthog-slack-secret
        key: signingSecret
  {{- end }}

  {{- if .SMTP }}
  email:
    host: {{ .SMTP.Server }}
    port: {{ .SMTP.Port }}
    user: {{ .SMTP.User }}
    password: {{ .SMTP.Password }}
    from_email: {{ .SMTP.Sender }}
  {{- end }}

  {{- if eq .Provider "aws" }}
  externalObjectStorage:
    endpoint: https://s3.{{ .Region }}.amazonaws.com
    bucket: {{ .Values.posthogBucket }}
  {{- end }}

clickhouse:
  password: {{ $chPassword }}
