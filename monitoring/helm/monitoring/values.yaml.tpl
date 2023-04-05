{{ $grafanaAgent := and .Configuration (index .Configuration "grafana-agent") }}
global:
  rbac:
    pspEnabled: false

{{ $monitoringNamespace := namespace "monitoring" }}
kube-prometheus-stack:
  grafana:
    namespaceOverride: {{ $monitoringNamespace }}
{{- if $grafanaAgent }}
  alertmanager:
    enabled: false
{{- end }}
  prometheus:
    {{- if $grafanaAgent }}
    enabled: false
    {{- end }}
    prometheusSpec:
      externalLabels:
        cluster: {{ .Cluster }}

{{- if .Configuration }}
{{- if .Configuration.loki }}
loki:
  enabled: false
promtail:
  enabled: false
{{- end }}
{{- if index .Configuration "grafana-tempo" }}
{{ $tempoNamespace := namespace "grafana-tempo" }}
opentelemetry-operator:
  collector:
    enabled: true
    tempoNamespace: {{ $tempoNamespace }}
{{- end }}
{{- end }}
