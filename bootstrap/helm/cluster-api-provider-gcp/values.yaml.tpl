cluster-api-provider-gcp:
  managerBootstrapCredentials:
    credentialsJson: {{ .Context.Credentials | quote | b64dec | quote }}
