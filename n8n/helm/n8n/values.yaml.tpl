global:
  application:
    links:
    - description: n8n web ui
      url: {{ .Values.hostname }}

webhookUrl: https://{{ .Values.hostname }}

{{ if .SMTP }}
smtp:
  host: {{ .SMTP.Server }}
  user: {{ .SMTP.User }}
  password: {{ .SMTP.Password }}
  port: {{ .SMTP.Port }}
  sender: {{ .SMTP.Sender }}
{{ end }}

ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: n8n-tls
     hosts:
       - {{ .Values.hostname }}
