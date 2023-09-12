{{- $monitoringNamespace := namespace "monitoring" -}}
{{- $mimir := and .Configuration .Configuration.mimir }}

global:
  application:
    links:
    - description: kiali web ui
      url: {{ .Values.hostname }}

virtualService:
  gateway: {{ namespace "istio-ingress" }}/istio-ingress

kiali-server:
  server:
    web_fqdn: {{ .Values.hostname }}
  {{- if .OIDC }}
  auth:
    strategy: openid
    openid:
      client_id: {{ .OIDC.ClientId }}
      client_secret: {{ .OIDC.ClientSecret }}
      issuer_uri: {{ .OIDC.Configuration.Issuer }}
  {{- end }}
  istio_namespace: {{ namespace "istio" }}
  external_services:
    istio:
      root_namespace: {{ namespace "istio" }}
      component_status:
        components:
        - app_label: istiod
          is_core: true
        - app_label: istio-ingress
          is_core: true
          is_proxy: true
          namespace: {{ namespace "istio-ingress" }}
    prometheus:
      {{- if $mimir }}
      url: http://mimir-nginx.mimir/prometheus
      custom_headers:
        X-Scope-OrgID: {{ .Cluster }}
      {{- else }}
      url: http://monitoring-prometheus.{{ $monitoringNamespace }}:9090
      {{- end }}
    {{- if .Configuration.grafana }}
    {{ $grafanaValues := .Applications.HelmValues "grafana" }}
    {{ $grafanaNamespace := namespace "grafana" }}
    grafana:
      enabled: true
      auth:
        username: {{ $grafanaValues.grafana.grafana.admin.user }}
        password: {{ $grafanaValues.grafana.grafana.admin.password }}
      url: https://{{ .Configuration.grafana.hostname }}
      in_cluster_url: http://grafana.{{ $grafanaNamespace }}:80
    {{- end }}
