configAwsOrGcp:
  wal_s3_bucket: {{ .Values.wal_bucket }}

serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-postgres"
