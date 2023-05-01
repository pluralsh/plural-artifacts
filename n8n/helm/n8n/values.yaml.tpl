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
  extraEnv:
    WEBHOOK_URL: https://{{ .Values.hostname }}
    WEBHOOK_TUNNEL_URL: https://{{ .Values.hostname }}

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
