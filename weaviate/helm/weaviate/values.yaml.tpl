{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}

{{ $key := dedupe . "weaviate.weaviate.admin.key" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: weaviate api
      url: {{ .Values.hostname }}

ingress:
  hosts:
  - host: {{ .Values.hostname }}
    paths:
      - path: '/'
        pathType: ImplementationSpecific
  tls:
  - secretName: weaviate-tls
    hosts:
      - {{ .Values.hostname }}

weaviate:
  authentication:
    anonymous_access:
      enabled: false
    apikey:
      enabled: true
      allowed_keys:
        - {{ $key }}
      users:
        - {{ .Values.adminEmail }}
  authorization:
    enabled: true
    adminlist:
      users:
        - {{ .Values.adminEmail }}
  backups:
    {{ if $isGcp }}
    gcs:
      enabled: true
      envconfig:
        BACKUP_GCS_BUCKET: {{ .Values.weaviateBucket }}
        BACKUP_GCS_USE_AUTH: "true"
    {{ end }}
