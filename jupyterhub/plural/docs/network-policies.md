# Network Policy

Jupyterhub makes extensive use of kubernetes network policies.  This allows you to finely scope a jupyter notebook's access to resources available on the network, which can be very important in a multi-tenant kubernetes cluster.  That said, you might want to expose some services to your network either on-cluster or in an adjacent network, and here are some recipes to do that.

In all cases, the following yaml will be added to `jupyterhub/helm/jupyterhub/values.yaml` or you can modify directly in the console at `/apps/jupyterhub/config`

## Get access to an adjacent namespace

```yaml
jupyterhub:
  jupyterhub:
    singleuser:
      networkPolicy:
        egress:
        - to:
          - namespaceSelector:
              matchLabels:
                kubernetes.io/metadata.name: <namespace>
```

## Get access to a CIDR range


```yaml
jupyterhub:
  jupyterhub:
    singleuser:
      networkPolicy:
        egress:
        - to:
          - ipBlock:
              cidr: 10.0.0.0/16 # access resources on an internal subnetwork for example
```

## Combine multiple policies


```yaml
jupyterhub:
  jupyterhub:
    singleuser:
      networkPolicy:
        egress:
        - to:
          - namespaceSelector:
              matchLabels:
                kubernetes.io/metadata.name: <namespace>
        - to:
          - ipBlock:
              cidr: 10.0.0.0/16
```