{{ $redisValues := .Applications.HelmValues "redis" }}
global:
  application:
    links:
    - description: jitsu web ui
      url: {{ .Values.hostname }}

{{ if .Values.airbyteEnabled }}
airbyte:
  enabled: "true"
{{ end }}

ingress:
  host: {{ .Values.hostname }}
  apiHost: {{ .Values.apiHostname }}

secrets:
  redis_host: redis-master.{{ namespace "redis" }}
  redis_password: {{ $redisValues.redis.password }}
  admin_token: {{ dedupe . "jitsu.jitsu.secrets.admin_token" (randAlphaNum 32) }}
  configurator_url: https://{{ .Values.hostname }}/configurator
  {{ if .SMTP }}
  smtp:
    user: {{ .SMTP.User }}
    password: {{ .SMTP.Password }}
    host: {{ .SMTP.Server }}
    port: {{ .SMTP.Port }}
    from: {{ .SMTP.Sender }}
  {{ end }}

config:
  server:
    name: {{ .Values.hostname }}
