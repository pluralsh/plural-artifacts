# Set Up External Ingress

If you'd like to access your elasticsearch cluster externally, you can do that with a relatively simply helm reconfiguration.  At `elasticsearch/helm/elasticsearch/values.yaml` add:

```yaml
elasticsearch:
  ingressElastic:
    enabled: true
    hostname: elasticsearch.CLUSTER_SUBDOMAIN
```

`CLUSTER_SUBDOMAIN` should be the same subdomain you use for all other apps in the cluster, if it were given something differently, externaldns and cert isssuance will fail and your install will not be accessible.