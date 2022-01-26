global:
  application:
    links:
    - description: kyverno web ui
      url: {{ .Values.hostname }}
