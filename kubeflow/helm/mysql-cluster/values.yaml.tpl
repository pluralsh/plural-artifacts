secret:
  rootPassword: {{ dedupe . "mysql-cluster.secret.rootPassword" (randAlphaNum 20) }}

{{- if eq .Provider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-mysql-operator"
{{- end }}
