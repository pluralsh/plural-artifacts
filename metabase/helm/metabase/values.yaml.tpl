global:
  application:
    links:
    - description: metabase web ui
      url: {{ .Values.hostname }}

ingress:
  hosts:
  - host: {{ .Values.hostname}}
    paths:
      - path: /.*
        pathType: ImplementationSpecific
  tls:
  - secretName: metabase-tls
    hosts:
      - {{ .Values.hostname }}