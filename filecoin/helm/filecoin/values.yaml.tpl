global:
  application:
    links: []
{{- if eq .Provider "aws" }}
lotus-fullnode:
  daemonConfig: |
    [API]
      ListenAddress = "/ip4/0.0.0.0/tcp/1234/http"
    [Libp2p]
      ListenAddresses = ["/ip4/0.0.0.0/tcp/1347"]
    [Chainstore]
      EnableSplitstore = true
  persistence:
    journal:
      enabled: true
      size: "10Gi"
      accessModes:
        - ReadWriteOnce
      storageClassName: ""
    datastore:
      enabled: true
      # Please also enable splitstore in the daemonConfig section
      splitStoreEnabled: true
      # when easyReset is true, if `/var/lib/lotus/datastore/_reset` is present, all files under
      # /var/lib/lotus/datastore/ will be removed when the pod restarts.
      easyReset: false
      # coldStore values are used if splitStoreEnabled: false
      coldStore:
        size: "5000Gi"
        accessModes:
          - ReadWriteMany
        storageClassName: efs-csi
      hotStore:
        size: "600Gi"
        accessModes:
          - ReadWriteOnce
        storageClassName: ""
    parameters:
      enabled: true
      size: "5Gi"
      accessModes:
        - ReadWriteOnce
      storageClassName: ""
  loadBalancer:
    enabled: true
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-name: {{ .Cluster }}-filecoin
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: '*'
      service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
      service.beta.kubernetes.io/aws-load-balancer-type: external
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: instance
  resources:
    requests:
      cpu: 7000m
      memory: 29Gi
{{- end }}
