armo-cluster-components:
  clusterName: plrl/{{ .Provider }}/{{ .Cluster }}
  accountGuid: {{ .Values.accountGuid }}
  armoNameSpace: {{ namespace "kubescape" }}