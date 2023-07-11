{{ $grafanaAgent := and .Configuration (index .Configuration "grafana-agent") }}
{{ $mimir := and .Configuration .Configuration.mimir }}
global:
  rbac:
    pspEnabled: false

{{ $monitoringNamespace := namespace "monitoring" }}
kube-prometheus-stack:
  grafana:
    namespaceOverride: {{ $monitoringNamespace }}
{{- if and $grafanaAgent $mimir }}
  alertmanager:
    enabled: false
{{- end }}
  prometheus:
    {{- if and $grafanaAgent $mimir }}
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
