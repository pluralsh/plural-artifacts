{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
global:
  application:
    links:
    - description: airbyte web ui
      url: {{ .Values.hostname }}
  {{ if $isGcp }}
  logs:
    storage:
      type: GCS
    gcs:
      bucket: {{ .Values.airbyteBucket }}
      credentials: ""
      credentialsJson: ""
  {{ else if ne .Provider "aws" }}
  logs:
    accessKey:
      password: {{ importValue "Terraform" "access_key_id" }}
    secretKey:
      password: {{ importValue "Terraform" "secret_access_key" }}
    storage:
      type: "MINIO"
    externalMinio:
      enabled: false
      host: https://{{ .Configuration.minio.hostname }}
      port: 443
  {{ else if eq .Provider "aws" }}
  logs:
    accessKey:
      password: {{ importValue "Terraform" "access_key_id" }}
    secretKey:
      password: {{ importValue "Terraform" "secret_access_key" }}
    storage:
      type: "S3"
    s3:
      enabled: true
      bucket: {{ .Values.airbyteBucket }}
      bucketRegion: {{ .Region }}
  {{ end }}


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

{{ if .Values.postgresDisabled }}
postgres: 
  enabled: false
{{ end }}

airbyte:
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
      enabled: false
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
