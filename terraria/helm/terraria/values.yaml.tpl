hostname: {{ .Values.hostname }}

terraria:
  worldsize: {{ .Values.worldsize }}
  settings:
    ServerPassword: {{ .Values.password }}
    RestApiEnabled: {{ .Values.restAPIEnabled }}
