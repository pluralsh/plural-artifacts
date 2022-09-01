global:
  rbac:
    pspEnabled: false

{{ $monitoringNamespace := namespace "monitoring" }}
kube-prometheus-stack:
  grafana:
    namespaceOverride: {{ $monitoringNamespace }}
  prometheus:
    prometheusSpec:
      externalLabels:
        cluster: {{ .Cluster }}

{{- if .Configuration }}
{{- if index .Configuration "grafana-tempo" }}
{{ $tempoNamespace := namespace "grafana-tempo" }}
opentelemetry-operator:
  collector:
    enabled: true
    tempoNamespace: {{ $tempoNamespace }}
{{- end }}
{{- end }}
