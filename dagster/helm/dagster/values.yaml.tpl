global:
  application:
    links:
    - description: dagster web ui
      url: {{ .Values.hostname }}

{{ $postgresPwd := dedupe . "dagster.postgres.password" (randAlphaNum 25) }}

postgres:
  password: {{ $postgresPwd }}

{{ if .OIDC }}
oidcProxy:
  enabled: true
  upstream: http://localhost:80
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "dagster.oidcProxy.cookieSecret" (randAlphaNum 32) }}
{{ end }}

dagster:
  {{ if .OIDC }}
  dagit:
    podLabels:
      security.plural.sh/inject-oauth-sidecar: "true"
    annotations:
      security.plural.sh/oauth-env-secret: "dagster-proxy-config"
  {{ end }}
  ingress:
    dagit:
      host: {{ .Values.hostname }}
      {{ if .OIDC }}
      precedingPaths:
      - path: /.*
        serviceName: dagster-oauth2-proxy
        servicePort: http-oauth
      {{ end }}

  generatePostgresqlPasswordSecret: true
  postgresql:
    postgresqlPassword: {{ $postgresPwd }}

  {{ if eq .Provider "aws" }}
  computeLogManager:
    type: S3ComputeLogManager
    config:
      s3ComputeLogManager:
        bucket: {{ .Values.dagsterBucket }}
  {{ end }}

  {{ if eq .Provider "aws" }}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-dagster"
  {{ end }}
  runLauncher:
    config:
      k8sRunLauncher:
      {{ if eq .Provider "aws" }}
        envSecrets:
        - name: dagster-aws-env
      {{ end }}