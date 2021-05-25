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
      config: |
        [[runners]]
          name = "plural-gitlab-runner"
          [runners.kubernetes]
            image = "ubuntu:18.04"
            privileged = true
            service_account = "gitlab-runner"
            poll_timeout = 360
            [runners.kubernetes.affinity]
              [runners.kubernetes.affinity.node_affinity]
                [[runners.kubernetes.affinity.node_affinity.preferred_during_scheduling_ignored_during_execution]]
                  weight = 20
                  [runners.kubernetes.affinity.node_affinity.preferred_during_scheduling_ignored_during_execution.preference]
                    [[runners.kubernetes.affinity.node_affinity.preferred_during_scheduling_ignored_during_execution.preference.match_expressions]]
                      key = "usage-intention"
                      operator = "In"
                      values = ["ci"]
          [[runners.kubernetes.volumes.empty_dir]]
            name = "docker-certs"
            mount_path = "/certs/client"
            medium = "Memory"
          {{ if eq .Provider "aws" }}
          [runners.cache]
            Type = "s3"
            Path = "runner"
            Shared = true
            [runners.cache.s3]
              ServerAddress = "s3.amazonaws.com"
              BucketName = "{{ .Values.runnerCacheBucket }}"
              BucketLocation = "{{ .Region }}"
              Insecure = false
          {{ end }}
          {{ if eq .Provider "google" }}
          [runners.cache]
            Type = "gcs"
            Path = "runner"
            Shared = true
            [runners.cache.gcs]
              BucketName = "{{ .Values.runnerCacheBucket }}"
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
