global:
  application:
    links:
    - description: minecraft server
      url: {{ .Values.hostname }}:25565

node:
  hostname: {{ .Values.hostname }}