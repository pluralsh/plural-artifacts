password: {{ dedupe . "redis.password" (randAlphaNum 26) }}

{{ $monitoringNamespace := namespace "monitoring" }}
{{ $grafanaNamespace := namespace "grafana" }}
monitoring:
  namespace: {{ $monitoringNamespace }}
  grafama:
    namespace: {{ $grafanaNamespace }}
