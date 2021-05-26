global:
  {{ if .Values.domain }}
  hosts:
    domain: {{ .Values.domain }}
  {{ end }}
  registry:
    bucket: {{ .Values.registryBucket }}
  appConfig:
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

rootPassword: {{ dedupe . "gitlab.rootPassword" (randAlphaNum 20) }}

serviceAccount:
{{ if eq .Provider "google" }}
  create: false
{{ end }}
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-gitlab-runner"
  
gitlab:
  registry:
    storage:
      secret: registry-connection
      key: config
  gitlab-runner:
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
