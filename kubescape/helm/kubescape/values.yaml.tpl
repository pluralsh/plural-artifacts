kubescape-cloud-operator:
  clusterName: plrl/{{ .Provider }}/{{ .Cluster }}
  account: {{ .Values.accountGuid }}
  armoNameSpace: {{ namespace "kubescape" }}