{{- else if eq .Provider "aws" }}
podAnnotations:
  iam.amazonaws.com/role: "arn:aws:iam::<AWS_ACCOUNT_ID>:role/<VELERO_ROLE_NAME>"
{{- end }}

