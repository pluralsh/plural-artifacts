armo-cluster-components:
  clusterName: plrl/{{ .Provider }}/{{ .Cluster }}
  accountGuid: {{ .Values.accountGuid }}
  armoNamespace: {{ namespace "kubescape" }}