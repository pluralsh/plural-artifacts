cluster-api-provider-aws:
  managerBootstrapCredentials:
    AWS_ACCESS_KEY_ID: {{ .Context.AccessKey | quote }}
    AWS_SECRET_ACCESS_KEY: {{ .Context.SecretAccessKey | quote }}
    AWS_SESSION_TOKEN: {{ .Context.SessionToken | quote }}
    AWS_REGION: {{ .Region | quote }}
  configVariables:
    awsControllerIamRole: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-capa-controller"
