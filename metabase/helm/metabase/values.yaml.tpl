global:
  application:
    links:
    - description: metabase web ui
      url: {{ .Values.hostname }}

database:
  encryptionKey: {{ dedupe . "metabase.database.encryptionKey" (randAlphaNum 32) }}

siteUrl: https://{{ .Values.hostname }}

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