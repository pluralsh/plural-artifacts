{{ $password := default "" .Values.password }}

provider: {{ .Provider }}
hostname: {{ .Values.hostname }}
serverName: {{ .Values.serverName }}
worldName: {{ .Values.worldName }}

{{ if $password }}
password: {{ .Values.password }}
{{ end }}

{{ if .Values.mod }}
mods:
  {{ if (eq .Values.mod "bepinex") }}
  bepinex: true
  {{ end }}
  {{ if (eq .Values.mod "valheimplus") }}
  valheimplus: true
  {{ end }}
{{ end }}
