{{- if .OIDC }}
oidcProxy:
  enabled: true
  upstream: http://localhost:8080
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "goldilocks.oidcProxy.cookieSecret" (randAlphaNum 32) }}
  ingress:
    host: {{ .Values.hostname }}

goldilocks:
  dashboard:
    deployment:
      additionalLabels:
        security.plural.sh/inject-oauth-sidecar: "true"
      annotations:
        security.plural.sh/oauth-env-secret: "goldilocks-oauth2-proxy-config"
{{- end }}
