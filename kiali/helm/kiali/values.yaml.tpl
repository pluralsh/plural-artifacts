{{- $monitoringNamespace := namespace "monitoring" -}}

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
      disable_rbac: true
      authentication_timeout: 300
      username_claim: email
      client_secret: {{ .OIDC.ClientSecret }}
      issuer_uri: {{ .OIDC.Configuration.Issuer }}
      scopes:
      - openid
      - profile
  {{- end }}
  istio_namespace: {{ namespace "istio" }}
  external_services:
    istio:
      root_namespace: {{ namespace "istio" }}
      component_status:
        enabled: true
        components:
        - app_label: istiod
          is_core: true
        - app_label: istio-ingress
          is_core: true
          is_proxy: true
          namespace: {{ namespace "istio-ingress" }}
    prometheus:
      url: http://monitoring-prometheus.{{ $monitoringNamespace }}:9090
