{{ $monitoringNamespace := namespace "monitoring" }}
{{ $grafanaNamespace := namespace "grafana" }}
global:
  prometheus:
    fqdn: http://monitoring-prometheus.{{ $monitoringNamespace }}.svc.cluster.local:9090
  grafana:
    domainName: grafana.{{ $grafanaNamespace }}.svc.cluster.local
  notifications:
    alertmanager: 
      fqdn: http://monitoring-alertmanager.{{ $monitoringNamespace }}.svc.cluster.local9093

cost-analyzer:
  kubecostProductConfigs:
    grafanaURL: https://{{ .Configuration.grafana.hostname }}
