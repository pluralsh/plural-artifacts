global:
  application:
    links:
    - description: n8n web ui
      url: {{ .Values.hostname }}

{{ $encryption := dedupe . "n8n.encryptionSecret" (randAlphaNum 24) }}

webhookUrl: https://{{ .Values.hostname }}

encryptionSecret: {{ $encryption }}

n8n:
  n8n:
    encryption_key: {{ $encryption }}
  config:
    host: {{ .Values.hostname }}
    port: 443
    protocol: https

  {{ if .SMTP }}
  secret:
    userManagement:
      emails:
        smtp:
          host: {{ .SMTP.Server }}
          port: {{ .SMTP.Port }}
          auth:
            user: {{ .SMTP.User }}
            pass: {{ .SMTP.Password }}
          sender: {{ .SMTP.Sender }}
  {{ end }}
  ingress:
    hosts:
    - host: {{ .Values.hostname }}
      paths:
      - /
    tls:
    - secretName: n8n-tls
      hosts:
        - {{ .Values.hostname }}
