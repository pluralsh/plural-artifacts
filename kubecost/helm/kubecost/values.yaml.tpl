{{ $monitoringNamespace := namespace "monitoring" }}
{{ $grafanaNamespace := namespace "grafana" }}
global:
  application:
    links:
    - description: kubecost web ui
      url: {{ .Values.hostname }}

  {{- if .OIDC }}
  additionalLabels:
    security.plural.sh/inject-oauth-sidecar: "true"
  podAnnotations:
    security.plural.sh/oauth-env-secret: "kubecost-oauth2-proxy-config"
  {{- end }}
  prometheus:
    fqdn: http://monitoring-prometheus.{{ $monitoringNamespace }}.svc.cluster.local:9090
  grafana:
    domainName: grafana.{{ $grafanaNamespace }}.svc.cluster.local
  notifications:
    alertmanager: 
      fqdn: http://monitoring-alertmanager.{{ $monitoringNamespace }}.svc.cluster.local9093

{{- if .OIDC }}
oidcProxy:
  enabled: true
  upstream: http://localhost:9090
  issuer: {{ .OIDC.Configuration.Issuer }}
  clientID: {{ .OIDC.ClientId }}
  clientSecret: {{ .OIDC.ClientSecret }}
  cookieSecret: {{ dedupe . "kubecost.oidcProxy.cookieSecret" (randAlphaNum 32) }}
  ingress:
    host: {{ .Values.hostname }}
{{- end }}

cost-analyzer:
  kubecostProductConfigs:
    grafanaURL: https://{{ .Configuration.grafana.hostname }}
