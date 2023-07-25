{{ $isAws := eq .Provider "aws" }}
{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
{{ $isAz := or (eq .Provider "azure") }}

{{ if .OIDC }}
podLabels:
  security.plural.sh/inject-oauth-sidecar: "true"
podAnnotations:
  security.plural.sh/oauth-env-secret: mlflow-proxy-config
  {{ if .Values.users }}
  security.plural.sh/htpasswd-secret: httpaswd-users
  {{ end }}

oidc-config:
  enabled: true
  secret:
    issuer: {{ .OIDC.Configuration.Issuer }}
    clientID: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "mlflow.oidc-config.secret.cookieSecret" (randAlphaNum 32) }}
  {{ if .Values.users }}
  users:
  {{ toYaml .Values.users | nindent 4 }}
  {{ end }}
{{ end }}

ingress:
  enabled: true
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: /
      pathType: ImplementationSpecific
  tls:
  - secretName: mlflow-tls
    hosts:
    - {{ .Values.hostname }}

config:
  artifact:
    type: {{ .Provider }}
    {{- if $isAws }}
    aws:
      bucketUri: s3://{{ .Values.mlflow_bucket }}/
    {{- else if $isGcp }}
    gcp:
      bucketUri: gs://{{ .Values.mlflow_bucket }}/
    {{- else if $isAz }}
    azure:
      accountName: {{ .Context.StorageAccount }}
      container: {{ .Values.mlflow_bucket }}
      existingSecret: mlflow-azure-secret
    {{- end }}

{{ if $isAws }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-mlflow"
{{ else if $isGcp }}
serviceAccount:
  annotations:
    iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
{{ end }}
