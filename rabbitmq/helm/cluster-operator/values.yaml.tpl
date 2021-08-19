{{ $monitoringNamespace := namespace "monitoring" }}
{{ $grafanaNamespace := namespace "grafana" }}
monitoring:
  namespace: {{ $monitoringNamespace }}
  grafama:
    namespace: {{ $grafanaNamespace }}
