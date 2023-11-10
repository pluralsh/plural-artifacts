global:
  application:
    links:
    - description: dremio ingress
      url: {{ .Values.hostname }}

dremio:
  ingress:
    tls:
      - hosts:
          - {{ .Values.hostname }}
        secretName: dremio-tls
    hosts:
      - {{ .Values.hostname }}