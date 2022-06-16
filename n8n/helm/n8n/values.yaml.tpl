global:
  application:
    links:
    - description: n8n web ui
      url: {{ .Values.hostname }}

n8n:
  ingress:
    tls:
    - host: {{ .Values.hostname }}
      secretName: n8n-tls
    host: {{ .Values.hostname }}

config:
  server:
    name: {{ .Values.hostname }}