{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}

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
  backups:
    {{ if $isGcp }}
    gcs:
      enabled: true
      envconfig:
        BACKUP_GCS_BUCKET: {{ .Values.weaviateBucket }}
        BACKUP_GCS_USE_AUTH: "true"
    {{ end }}
