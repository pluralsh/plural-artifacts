{{- if eq .Provider "aws" }}
infrastructureProvider:
  aws:
    enabled: true
    secretData:
      AWS_REGION: {{ .Region }}
    bootstrapCredentials:
      AWS_ACCESS_KEY_ID: {{ .Context.AccessKey | quote }}
      AWS_SECRET_ACCESS_KEY: {{ .Context.SecretAccessKey | quote }}
      AWS_SESSION_TOKEN: {{ .Context.SessionToken | quote }}
    credentials:
      AWS_CONTROLLER_IAM_ROLE: {{ importValue "Terraform" "capa_iam_role_arn" }}
{{- end }}
