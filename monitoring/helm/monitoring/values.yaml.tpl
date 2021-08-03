{{ $grafanaNamespace := namespace "grafana" }}
kube-prometheus-stack:
  grafana:
    namespaceOverride: {{ $grafanaNamespace }}
