agent:
  clusterName: {{ .Cluster }}
logs:
  agent:
    lokiTenantId: {{ .Cluster }}
traces:
  agent:
    lokiTenantId: {{ .Cluster }}
