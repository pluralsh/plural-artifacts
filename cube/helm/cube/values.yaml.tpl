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
      bucket: {{ .Values.cubeBucket }}
      region: {{ .Region }}
  router:
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
  workers:
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
{{ end }}
{{ end }}
