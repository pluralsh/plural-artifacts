{{- if .OIDC }}
oidcProxy:
  enabled: true
  upstream: http://localhost:3000
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "mysql.oidcProxy.cookieSecret" (randAlphaNum 32) }}
  ingress:
    host: {{ .Values.hostname }}
{{- end }}

mysql-operator:
  orchestrator:
    topologyPassword: {{ dedupe . "mysql.mysql-operator.orchestrator.topologyPassword" (randAlphaNum 10) }}
