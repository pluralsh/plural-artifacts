{{ $password := default "" .Values.password }}

hostname: {{ .Values.hostname }}

terraria:
  worldsize: {{ .Values.worldsize }}
  settings:
    {{ if $password }}
    ServerPassword: {{ $password }}
    {{ end }}
    RestApiEnabled: {{ .Values.restAPIEnabled }}
