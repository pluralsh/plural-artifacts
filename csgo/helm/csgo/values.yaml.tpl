provider: {{ .Provider }}
hostname: {{ .Values.hostname }}

service:
  port: {{ .Values.port }}
  gotvPort: {{ .Values.gotvPort }}

config:
  settings:
    token: {{ .Values.token }}
    password: {{ .Values.password }}
    rconPassword: {{ .Values.rconPassword }}
    tickrate: {{ .Values.tickrate }}
    maxPlayers: {{ .Values.maxPlayers }}
    fpsMax: {{ .Values.fpsMax }}
