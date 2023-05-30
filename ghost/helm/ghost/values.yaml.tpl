
{{ $prevRootPwd := dedupe . "ghost.db.rootPassword" (randAlphaNum 26) }}
{{ $prevDBPwd := dedupe . "ghost.db.password" (randAlphaNum 26) }}
{{ $dbPwd := dedupe . "ghost.mysql.appPassword" $prevDBPwd }}
{{- $mysqlVals := .Applications.TerraformValues "mysql" -}}
{{- $isGcp := or (eq .Provider "google") (eq .Provider "gcp") -}}

global:
  application:
    links:
    - description: ghost web address
      url: {{ .Values.ghostDomain }}
    - description: ghost admin interface
      url: {{ .Values.ghostDomain }}/ghost

ghost:
  env:
    {{- if .Values.ghostPath }}
    url: https://{{ .Values.ghostDomain }}/{{ .Values.ghostPath }}/
    {{- else }}
    url: https://{{ .Values.ghostDomain }}/
    {{- end }}
    database__connection__password: {{ $dbPwd }}
    mail__from: {{ .Values.ghostEmail }}

ingress:
  hosts:
    - host: {{ .Values.ghostDomain }}
      paths:
      {{- if .Values.ghostPath }}
        - path: /{{ .Values.ghostPath }}(/|$)(.*)
          pathType: Prefix
      {{- else }}
        - path: /
          pathType: ImplementationSpecific
      {{- end }}
  tls:
   - secretName: ghost-tls
     hosts:
       - {{ .Values.ghostDomain }}

mysql:
  appPassword: {{ $dbPwd }}
  rootPassword: {{ dedupe . "ghost.mysql.rootPassword" $prevRootPwd }}

  {{- if eq .Provider "aws" }}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: {{ $mysqlVals.iam_role_arn }}

  backupURL: s3://{{ .Configuration.mysql.backup_bucket }}/ghost
  backupCredentials:
    S3_PROVIDER: AWS
    RCLONE_S3_ENV_AUTH: "true"
  {{- else if $isGcp }}
  serviceAccount:
    annotations:
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}

  backupURL: gs://{{ .Configuration.mysql.backup_bucket }}/ghost
  backupCredentials:
    GCS_PROJECT_ID: {{ .Project }}
  {{- end }}
