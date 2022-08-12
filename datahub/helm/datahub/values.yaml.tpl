global:
  application:
    links:
    - description: datahub web ui
      url: {{ .Values.hostname }}