infrastructure:
  provider: {{ .Provider }}

{{ if eq .Provider "aws" }}
aws:
  expMachinePool: true
  accessKey: {{ .Context.AccessKey }}
  secretAccessKey: {{ .Context.SecretAccessKey }}
{{ end }}