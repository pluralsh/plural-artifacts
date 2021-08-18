mysql-operator:
  orchestrator:
    topologyPassword: {{ dedupe . "mysql.mysql-operator.orchestrator.topologyPassword" (randAlphaNum 10) }}

{{ $monitoringNamespace := namespace "monitoring" }}
{{ $grafanaNamespace := namespace "grafana" }}
monitoring:
  namespace: {{ $monitoringNamespace }}
  grafama:
    namespace: {{ $grafanaNamespace }}
