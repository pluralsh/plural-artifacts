secrets:
  redis_password: {{ dedupe . "airflow.secrets.redis_password" (randAlphaNum 14) }}

sshConfig:
{{ if and (hasKey . "airflow") (hasKey .airflow "ssConfig") }}
  id_rsa: {{ .airflow.sshConfig.id_rsa }}
  id_rsa_pub: {{ .airflow.sshConfig.id_rsa_pub }}
{{ else if .Values.hostname }}
  {{ $id_rsa := readLineDefault "Enter the path to your deploy keys" (homeDir ".ssh" "id_rsa") }}
  id_rsa: {{ readFile $id_rsa | quote }}
  id_rsa_pub: {{ readFile (printf "%s.pub" $id_rsa) | quote }}
{{ else }}
  id_rsa: example
  id_rsa_pub: example
{{ end }}

{{ $hostname := default .Values.hostname "https://example.com" }}
airflow:
  postgresql:
    postgresqlPassword: {{ dedupe . "airflow.postgresql.postgresqlPassword" (randAlphaNum 20) }}
  web:
    baseUrl: {{ $hostname }}
  ingress:
    web:
      host: {{ $hostname }}

  fernetKey: {{ dedupe . "airflow.airflow.fernetKey" (randAlphaNum 20)}}

  airflow:
    config:
      AIRFLOW__WEBSERVER__BASE_URL: https://{{ $hostname }}/
    {{ if eq .Provider "google" }}
      AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER: "gs://{{ .Values.airflowBucket }}/airflow/logs"
    {{ end }}
    {{ if eq .Provider "aws" }}
      AIRFLOW__LOGGING__REMOTE_BASE_LOG_FOLDER: "s3://{{ .Values.airflowBucket }}/airflow/logs"
    {{ end }}
    users:
    - username: {{ .Values.adminUsername }}
      password: CHANGEME
      role: Admin
      email: {{ .Values.adminEmail }}
      firstName: {{ .Values.adminFirst }}
      lastName: {{ .Values.adminLast }}
  
    {{ if eq .Provider "google" }}
    connections:
    ## see docs: https://airflow.apache.org/docs/apache-airflow-providers-google/stable/connections/gcp.html
    - id: my_gcp
      type: google_cloud_platform
      description: my GCP connection
      extra: |-
        { "extra__google_cloud_platform__num_retries": "5" }
    {{ end }}

  serviceAccount:
  {{ if eq .Provider "google" }}
    create: false
  {{ end }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-airflow"

  dags:
    gitSync:
      enabled: true
      repo: {{ .Values.dagRepo }}
      branch: {{ .Values.branchName }}
      revision: HEAD
      syncWait: 60
      sshSecret: airflow-ssh-config
      sshSecretKey: id_rsa