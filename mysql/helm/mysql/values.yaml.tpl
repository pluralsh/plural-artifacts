{{- if .OIDC }}
oidcProxy:
  enabled: true
  upstream: http://localhost:3000
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "kubecost.oidcProxy.cookieSecret" (randAlphaNum 32) }}
  ingress:
    host: {{ .Values.hostname }}
{{- end }}

mysql-operator:
  {{- if .OIDC }}
  podLabels:
    security.plural.sh/inject-oauth-sidecar: "true"
  podAnnotations:
    security.plural.sh/oauth-env-secret: "mysql-oauth2-proxy-config"
  {{- end }}
  orchestrator:
    topologyPassword: {{ dedupe . "mysql.mysql-operator.orchestrator.topologyPassword" (randAlphaNum 10) }}
