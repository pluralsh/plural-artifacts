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
    labels:
      security.plural.sh/inject-oauth-sidecar: "true"
    deploymentLabels:
      security.plural.sh/inject-oauth-sidecar: "true"
    annotations:
      app.plural.sh/dedupe-count: '1'
      security.plural.sh/oauth-env-secret: "dagster-proxy-config"
    {{ if eq .Provider "azure" }}
    envSecrets:
    - name: dagster-aws-env
    {{ end }}
  {{ end }}
  ingress:
    dagit:
      host: {{ .Values.hostname }}
      {{ if .OIDC }}
      precedingPaths:
      - path: /.*
        pathType: ImplementationSpecific
        serviceName: dagster-oauth2-proxy
        servicePort: http-oauth
      {{ end }}

  generatePostgresqlPasswordSecret: true
  postgresql:
    postgresqlPassword: {{ $postgresPwd }}

  {{ $minioNamespace := namespace "minio" }}
  {{ if or (eq .Provider "aws") (eq .Provider "azure") }}
  computeLogManager:
    type: S3ComputeLogManager
    config:
      s3ComputeLogManager:
        bucket: {{ .Values.dagsterBucket }}
      {{ if eq .Provider "azure" }}
        endpointUrl: http://minio.{{ $minioNamespace }}:9000
      {{ end }}
  {{ end }}

  {{ if eq .Provider "gcp" }}
  computeLogManager:
    type: GCSComputeLogManager
    config:
      gcsComputeLogManager:
        bucket: {{ .Values.dagsterBucket }}
  {{ end}}

  {{ if eq .Provider "aws" }}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-dagster"
  {{ end }}

  {{ if eq .Provider "gcp" }}
  serviceAccount:
    annotations:
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
  {{ end }}

  runLauncher:
    config:
      k8sRunLauncher:
        envSecrets:
        - name: dagster-aws-env