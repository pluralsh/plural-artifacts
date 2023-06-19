agent:
  clusterName: {{ .Cluster }}
metricsInstance:
  remoteWrite:
    mimir:
      headers:
        X-Scope-OrgID: {{ .Cluster }}
logInstance:
  clients:
    loki:
      tenantId: {{ .Cluster }}
      externalLabels:
        cluster: {{ .Cluster }}
traces:
  agent:
    lokiTenantId: {{ .Cluster }}
    tempoTenantId: {{ .Cluster }}
