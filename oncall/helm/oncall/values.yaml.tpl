{{- $redisNamespace := namespace "redis" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
{{- $rabbitmqNamespace := namespace "rabbitmq" }}

global:
  application:
    links:
    - description: oncall public endpoint
      url: {{ .Values.hostname }}

rabbitmq:
  cluster:
    namespace: {{ $rabbitmqNamespace }}  

oncall:
  base_url: {{ .Values.hostname }}
  ingress:
    enabled: true
    tls: 
      - hosts:
          - {{ .Values.hostname }}
        secretName: oncall-certificate-tls
  externalRabbitmq:
    host: rabbitmq.{{ $rabbitmqNamespace }}
  externalRedis:
    host: redis-master.{{ $redisNamespace }}
    password: {{ $redisValues.redis.password }}
  {{ if .SMTP }}
  oncall:
    smtp:
      enabled: true
      host: {{ .SMTP.Server }}
      port: {{ .SMTP.Port }}
      username: {{ .SMTP.User }}
      password: {{ .SMTP.Password }}
      fromEmail: {{ .SMTP.Sender }}
      tls: true
  {{ end }}
