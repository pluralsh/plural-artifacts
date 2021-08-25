{{ $monitoringNamespace := namespace "monitoring" }}
{{ $grafanaNamespace := namespace "grafana" }}
global:
  prometheus:
    enabled: false
    fqdn: http://monitoring-prometheus.{{ $monitoringNamespace }}.svc.cluster.local:9090
  grafana:
    enabled: false
    domainName: grafana.{{ $grafanaNamespace }}.svc.cluster.local

kubecostProductConfigs:
  grafanaURL: https://{{ .Configuration.grafana.hostname }}
