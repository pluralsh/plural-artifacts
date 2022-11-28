prefect-orion:
  ingress:
    host:
      hostname: {{ .Values.hostname}}
  orion:
    env:
    - name: PREFECT_API_URL
      value: https://{{ .Values.hostname}}/api
