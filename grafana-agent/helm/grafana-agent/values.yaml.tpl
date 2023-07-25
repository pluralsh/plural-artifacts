{{ $tempo := and .Configuration .Configuration.tempo }}
{{- $loki := and .Configuration .Configuration.loki }}
{{- $mimir := and .Configuration .Configuration.mimir }}
agent:
  {{- if or $mimir $loki }}
  enabled: true
  {{- end }}
  clusterName: {{ .Cluster }}
metricsInstance:
  {{- if $mimir }}
  enabled: true
  {{- end }}
  remoteWrite:
    mimir:
      headers:
        X-Scope-OrgID: {{ .Cluster }}
logInstance:
  {{- if $loki }}
  enabled: true
  {{- end }}
  clients:
    loki:
      tenantId: {{ .Cluster }}
      externalLabels:
        cluster: {{ .Cluster }}
{{- if $loki }}
podLogs:
  enabled: true
{{- end }}
traces:
  {{- if $tempo }}
  enabled: true
  {{- end }}
  agent:
    lokiTenantId: {{ .Cluster }}
    tempoTenantId: {{ .Cluster }}
