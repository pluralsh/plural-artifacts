# etcd

Installs etcd using Plural.

Example cluster CRD:

```yaml
apiVersion: etcd.improbable.io/v1alpha1
kind: EtcdCluster
metadata:
  name: etcd-example
  namespace: etcd
spec:
  replicas: 3
  version: 3.5.0
  storage:
    volumeClaimTemplate:
      storageClassName: "gp2" # storage class is required, change if not running on AWS
      resources:
        requests:
          storage: 1Gi
  podTemplate:
    resources:
      requests:
        cpu: 200m
        memory: 200Mi
      limits:
        cpu: 200m
        memory: 200Mi
    etcdEnv:
      - name: "ETCD_HEARTBEAT_INTERVAL"
        value: "100"
      - name: "ETCD_ELECTION_TIMEOUT"
        value: "5000"
      - name: "ETCD_MAX_SNAPSHOTS"
        value: "10"
      - name: "ETCD_MAX_WALS"
        value: "10"
      - name: "ETCD_QUOTA_BACKEND_BYTES"
        value: "8589934592"
      - name: "ETCD_SNAPSHOT_COUNT"
        value: "100000"
      - name: "ETCD_AUTO_COMPACTION_RETENTION"
        value: "20000"
      - name: "ETCD_AUTO_COMPACTION_MODE"
        value: "revision"
    affinity:
      podAntiAffinity:
        preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 100
            podAffinityTerm:
              labelSelector:
                matchExpressions:
                  - key: etcd.improbable.io/cluster-name
                    operator: In
                    values:
                      - etcd-example # set this value to the name of the spec so pods don't deploy on the same host
              topologyKey: kubernetes.io/hostname
```
