global:
  application:
    links:
    - description: kibana web ui
      url: {{ .Values.hostname }}