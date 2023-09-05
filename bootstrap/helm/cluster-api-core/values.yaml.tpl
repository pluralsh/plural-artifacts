{{- if eq .Provider "aws" }}
cluster-api-core:
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-capa-controller"
{{- end }}
