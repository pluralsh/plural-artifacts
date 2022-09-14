{{ $password := default "" .Values.password }}

provider: {{ .Provider }}
hostname: {{ .Values.hostname }}

service:
  port: {{ .Values.port }}
  gotvPort: {{ .Values.gotvPort }}

config:
  settings:
    token: {{ .Values.token }}
    {{ if $password }}
    password: {{ .Values.password }}
    {{ end }}
    rconPassword: {{ dedupe . "csgo.config.settings.rconPassword" (randAlphaNum 12) }}
    tickrate: {{ .Values.tickrate }}
    maxPlayers: {{ .Values.maxPlayers }}
    fpsMax: {{ .Values.fpsMax }}
