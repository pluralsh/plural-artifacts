global:
  application:
    links:
    - description: counterstrike scrds endpoint
      url: {{ .Values.hostname }}:27016
    - description: counterstrike scrds tv endpoint
      url: {{ .Values.hostname }}:27021

hostname: {{ .Values.hostname }}

secrets:
  token: {{ .Values.token | default "example" }}
  password: {{ .Values.password | default "changeme" }}
  {{ if .Values.rconPassword }}
  rconPassword: {{ .Values.rconPassword }}
  {{ end }}