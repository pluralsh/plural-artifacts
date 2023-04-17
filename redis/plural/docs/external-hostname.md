# Expose Redis Outside Cluster

We ship redis with only internal cluster networking by default for security reasons, but you can still expose either the redis master or replicas externally from the cluster.  The process simply involves editing the `context.yaml` file at the root of your repo with:

```
configuration:
  ...
  redis:
    masterHostname: redis-master.CLUSTER-SUBDOMAIN
    replicaHostname: redis-replica.CLUSTER-SUBDOMAIN # if you want to expose the replica as well
```

you can then simply run: `plural build --only redis && plural deploy --commit "expose redis"`