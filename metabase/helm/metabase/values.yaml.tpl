global:
  application:
    links:
    - description: metabase web ui
      url: {{ .Values.hostname }}

{{ if not .Values.postgresqlDisabled }}
database:
  encryptionKey: {{ dedupe . "metabase.database.encryptionKey" (randAlphaNum 32) }}
  operatorEnabled: true
{{ else }}
database: 
  encryptionKey: {{ dedupe . "metabase.database.encryptionKey" (randAlphaNum 32) }}
  operatorEnabled: false
{{ end }}

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