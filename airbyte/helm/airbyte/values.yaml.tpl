global:
  application:
    links:
    - description: airbyte web ui
      url: {{ .Values.hostname }}

{{ if .OIDC }}
{{ $prevSecret := dedupe . "airbyte.oidcProxy.cookieSecret" (randAlphaNum 32) }}
oidc-config:
  enabled: true
  secret:
    name: airbyte-proxy-config
    issuer: {{ .OIDC.Configuration.Issuer }}
    clientID: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "airbyte.oidc-config.secret.cookieSecret" $prevSecret }}
  service:
    name: airbyte-oauth2-proxy
    selector:
      airbyte: webapp
  {{ if .Values.users }}
  users:
  {{ toYaml .Values.users | nindent 4 }}
  {{ end }}
{{ end }}

{{ if .Values.privateHostname }}
private:
  ingress:
    enabled: true
    tls:
    - hosts:
      - {{ .Values.privateHostname }}
      secretName: airbyte-private-tls
    hosts:
    - host: {{ .Values.privateHostname }}
      paths:
      - path: '/.*'
        pathType: ImplementationSpecific
{{ end }}

{{ $minioNamespace := namespace "minio" }}

{{ if not .Values.postgresDisabled }}
airbyte:
  postgresql:
    enabled: false
  postgres:
    enabled: true
{{ else }}
airbyte:
  postgresql:
    enabled: false
  postgres: 
    enabled: false
{{ end }}

{{ if or (eq .Provider "google") (eq .Provider "azure") (eq .Provider "kind") }}
  airbyteS3Bucket: {{ .Values.airbyteBucket }}
  minio:
    accessKey:
      password: {{ importValue "Terraform" "access_key_id" }}
    secretKey:
      password: {{ importValue "Terraform" "secret_access_key" }}
{{ end }}
{{ if eq .Provider "google" }}
  airbyteS3Endpoint: https://storage.googleapis.com
{{ end }}
{{ if eq .Provider "azure" }}
  airbyteS3Endpoint: https://{{ .Configuration.minio.hostname }}
{{ end }}
{{ if eq .Provider "kind" }}
  airbyteS3Endpoint: http://minio.{{ $minioNamespace }}:9000
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
    {{ if .Values.users }}
      security.plural.sh/htpasswd-secret: httpaswd-users
    {{ end }}
    {{ end }}
    ingress:
      enabled: true
      {{- if eq .Provider "kind" }}
      annotations:
        external-dns.alpha.kubernetes.io/target: "127.0.0.1"
      {{- end }}
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
