{{ $istioNamespace := namespace "istio" }}
{{ $hostname := .Values.hostname }}
global:
  istioNamespace: {{ $istioNamespace }}
  domain: {{ $hostname }}

{{- if .OIDC }}
oidcProxy:
  enabled: true
  upstream: static://200
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "central-dashboard.oidcProxy.cookieSecret" (randAlphaNum 32) }}

podLabels:
  security.plural.sh/inject-oauth-sidecar: "true"
podAnnotations:
  security.plural.sh/oauth-env-secret: "kubeflow-oauth2-proxy-config"
{{- end }}
