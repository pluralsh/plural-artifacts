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

{{ if or ($isGcp) (eq .Provider "aws) }}
cubestore:
  cloudStorage:
    {{ if $isGcp }}
    gcp:
      credentialsFromSecret:
        name: cube-gcp-credentials
        key: key.json
      bucket: {{ .Values.cubeBucket }}
    {{ else if eq .Provider "aws" }}
    aws:
      accessKeyID: {{ importValue "Terraform" "iam_access_key_id" }}
      secretKey: {{ importValue "Terraform" "iam_access_key_secret" }}
      bucket: {{ .Values.cubeBucket }}
      region: {{ .Region }}
    {{ end }}
{{ end }}