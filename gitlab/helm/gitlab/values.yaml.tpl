global:
  {{ if .Network }}
  hosts:
    domain: {{ .Network.Subdomain }}
  {{ end }}
  {{ if .SMTP }}
  email:
    display_name: GitLab
    from: {{ .SMTP.Sender }}
  smtp:
    enabled: true
    address: {{ .SMTP.Server }}
    authentication: 'plain'
    port: {{ .SMTP.Port }}
    user_name: {{ .SMTP.User }}
  {{ end }}
  registry:
    bucket: {{ .Values.registryBucket }}
  appConfig:
    {{ if .OIDC }}
    omniauth:
      enabled: true
      autoLinkUser: true
      allowSingleSignOn: true
      blockAutoCreatedUsers: false
      providers:
      - secret: plural-oidc-provider
        key: provider
    {{ end }}
    lfs:
      bucket: {{ .Values.lfsBucket }}
      connection: # https://gitlab.com/gitlab-org/charts/gitlab/blob/master/doc/charts/globals.md#connection
        secret: objectstore-connection
        key: connection
    artifacts:
      bucket: {{ .Values.artifactsBucket }}
      connection:
        secret: objectstore-connection
        key: connection
    uploads:
      bucket: {{ .Values.uploadsBucket }}
      connection:
        secret: objectstore-connection
        key: connection
    packages:
      bucket: {{ .Values.packagesBucket }}
      connection:
        secret: objectstore-connection
        key: connection
    backups:
      bucket: {{ .Values.backupsBucket }}
      tmpBucket: {{ .Values.backupsTmpBucket }}
      connection:
        secret: objectstore-connection
        key: connection
  serviceAccount:
    {{ if eq .Provider "google" }}
    create: false
    {{ end }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-gitlab"

{{ if .OIDC }}
oidc:
  name: openid_connect
  label: Plural
  icon: https://plural-assets.s3.us-east-2.amazonaws.com/uploads/repos/3fbf2a2b-6416-4245-ad28-3c2fb74aac86/plural-logo.png?v=63791948408
  args:
    name: openid_connect
    issuer: {{ .OIDC.Configuration.Issuer }}
    scope: [openid]
    discovery: true
    client_options:
      identifier: {{ .OIDC.ClientId }}
      secret: {{ .OIDC.ClientSecret }}
      redirect_uri: https://gitlab.{{ .Values.domain }}/users/auth/openid_connect/callback
{{ end }}

{{ if .SMTP }}
smtpPassword: {{ .SMTP.Password }}
{{ end }}
rootPassword: {{ dedupe . "gitlab.rootPassword" (randAlphaNum 20) }}

gitlab:
  registry:
    storage:
      secret: registry-connection
      key: config
    runners:
      cache:
      {{ if eq .Provider "aws" }}
        cacheType: s3
        s3BucketName: {{ .Values.runnerCacheBucket }}
        s3BucketLocation: {{ .Region }}
      {{ end }}
      {{ if eq .Provider "google" }}
        cacheType: gcs
        gcsBucketName: {{ .Values.runnerCacheBucket }}
      {{ end }}
          


railsConnection:
{{ if eq .Provider "google" }}
  provider: Google
  google_project: {{ .Project }}
  google_application_default: true
{{ end }}
{{ if eq .Provider "aws" }}
  provider: AWS
  region: {{ .Region }}
  use_iam_profile: true
{{ end }}

registryConnection:
{{ if eq .Provider "aws" }}
  s3:
    bucket: {{ .Values.registryBucket }}
    region: {{ .Region }}
    v4auth: true
    
{{ end }}
{{ if eq .Provider "google" }}
  gcs:
    bucket: {{ .Values.registryBucket }}
{{ end }}
