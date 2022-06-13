global:
  application:
    links:
    - description: n8n web ui
      url: {{ .Values.hostname }}

ingress:
  host: {{ .Values.hostname }}

config:
  server:
    name: {{ .Values.hostname }}