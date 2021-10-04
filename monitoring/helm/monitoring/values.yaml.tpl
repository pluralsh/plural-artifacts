{{ $grafanaNamespace := namespace "grafana" }}
kube-prometheus-stack:
  grafana:
    namespaceOverride: {{ $grafanaNamespace }}

{{- if .Configuration }}
{{- if index .Configuration "grafana-tempo" }}
{{ $tempoNamespace := namespace "grafana-tempo" }}
opentelemetry-operator:
  collector:
    enabled: true
    tempoNamespace: {{ $tempoNamespace }}
{{- end }}
{{- end }}
