{{ $redisValues := .Applications.HelmValues "redis" }}
global:
  application:
    links:
    - description: jitsu web ui
      url: {{ .Values.hostname }}

ingress:
  host: {{ .Values.hostname }}
  apiHost: {{ .Values.apiHostname }}

secrets:
  redis_host: redis-master.{{ namespace "redis" }}
  redis_password: {{ $redisValues.redis.password }}
  admin_token: {{ dedupe . "jitsu.jitsu.secrets.admin_token" (randAlphaNum 32) }}
  configurator_url: https://{{ .Values.hostname }}/configurator

config:
  server:
    name: {{ .Values.hostname }}
