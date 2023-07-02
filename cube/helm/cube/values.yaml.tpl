{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
{{ $apiSecret := dedupe . "cube.cube.config.apiSecret" (randAlphaNum 40) }}

global:
  application:
    links:
    - description: cube api
      url: {{ .Values.hostname }}

cube:
  ingress:
    hostname: {{ .Values.hostname }}
  config:
    apiSecret: {{ $apiSecret }}
  datasources:
    default:
      type: {{ .Values.databaseType }}

cubestore:
  cloudStorage:
{{ if $isGcp }}
    gcp:
      credentialsFromSecret:
        name: cube-gcp-credentials
        key: key.json
      bucket: {{ .Values.cubeBucket }}
{{ end }}