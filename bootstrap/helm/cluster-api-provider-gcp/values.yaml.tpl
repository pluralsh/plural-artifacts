cluster-api-provider-gcp:
  managerBootstrapCredentials:
    credentialsJson: {{ .Context.Credentials | b64dec | quote }}