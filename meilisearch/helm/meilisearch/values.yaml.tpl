{{ $masterKey := dedupe . "meilisearch.meilisearch.masterKey" (randAlphaNum 30) }}

global:
  application:
    links:
    - description: meilisearch web ui
      url: {{ .Values.hostname }}

meilisearch:
  masterKey: {{ $masterKey }}
  ingress:
    hosts: [{{ .Values.hostname }}]
    tls:
    - secretName: meilisearch-tls
      hosts:
        - {{ .Values.hostname }}
  auth:
      existingMasterKeySecret: meilisearch-secret