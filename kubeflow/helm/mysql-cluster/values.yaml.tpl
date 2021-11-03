secret:
  rootPassword: {{ dedupe . "mysql-cluster.secret.rootPassword" (randAlphaNum 20) }}

{{- if eq .Provider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-mysql-operator"
{{- end }}

backup:
  backupSchedule: "0 0 * * * *"
{{- if eq .Provider "aws" }}
  backupURL: s3://{{ .Configuration.mysql.backup_bucket }}
{{- end }}
  backupScheduleJobsHistoryLimit: 10
  backupRemoteDeletePolicy: delete
