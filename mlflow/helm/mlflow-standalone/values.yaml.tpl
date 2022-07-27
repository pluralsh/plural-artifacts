global:
  application:
    links:
    - description: mlflow web ui
      url: {{ .Values.hostname }}

{{- if .OIDC }}
{{ $prevSecret := dedupe . "mlflow-standalone.oidcProxy.cookieSecret" (randAlphaNum 32) }}
oidc-config:
  enabled: true
  secret:
    name: mlflow-oauth2-proxy-config
    upstream: http://localhost:5000
    issuer: {{ .OIDC.Configuration.Issuer }}
    clientID: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    cookieSecret: {{ dedupe . "mlflow-standalone.oidc-config.secret.cookieSecret" $prevSecret }}
  service:
    name: mlflow-oauth2-proxy
    selector:
      statefulset: trackingserver
  {{ if .Values.users }}
  users:
  {{ toYaml .Values.users | nindent 4 }}
  {{ end }}
{{- end }}

mlflow:
  defaultArtifactRoot: {{ .Values.mlflow_bucket }}

ingress:
  enabled: true
  hosts:
    - host: {{ .Values.hostname }}
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls:
    - secretName: mlflow-standalone-tls
      hosts:
        - {{ .Values.hostname }}

{{- if eq .Provider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-mlflow"
{{- end }}
