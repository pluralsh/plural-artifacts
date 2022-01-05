global:
  application:
    links:
    - description: airbyte web ui
      url: {{ .Values.hostname }}

{{ if .OIDC }}
oidcProxy:
  enabled: true
  upstream: http://localhost:80
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "airbyte.oidcProxy.cookieSecret" (randAlphaNum 32) }}
{{ end }}

{{ if eq .Provider "google" }}
postgresNamespace: {{ namespace "postgres" }}
{{ end }}

airbyte:
{{ if eq .Provider "google" }}
  gcpCredentialsSecret: airbyte-gcp-credentials
  airbyteGCSBucket: {{ .Values.airbyteBucket }}
  googleApplicationCredentials: /secrets/gcs-log-creds/credentials.json
{{ end }}
{{ if eq .Provider "aws" }}
  airbyteS3Bucket: {{ .Values.airbyteBucket }}
  airbyteS3Region: {{ .Region }}
  minio:
    accessKey:
      password: {{ importValue "Terraform" "access_key_id" }}
    secretKey:
      password: {{ importValue "Terraform" "secret_access_key" }}
{{ end }}
  webapp:
    {{ if .OIDC }}
    podLabels:
      security.plural.sh/inject-oauth-sidecar: "true"
    podAnnotations:
      security.plural.sh/oauth-env-secret: "airbyte-proxy-config"
    {{ end }}
    ingress:
      tls:
      - hosts:
        - {{ .Values.hostname }}
        secretName: airbyte-tls
      hosts:
      - host: {{ .Values.hostname }}
        paths:
        - path: '/.*'
          pathType: ImplementationSpecific
      {{ if .OIDC }}
      service:
        name: airbyte-oauth2-proxy
        port: 80
      {{ end }}
