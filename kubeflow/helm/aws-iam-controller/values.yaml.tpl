aws:
  region: {{ .Region }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-aws-ack-iam
