# Deploying on a private network

To deploy your dagster instance on a private network, the simplest solution is to use our provided private ingress class, which can be done easily by adding the following to `dagster/helm/dagster/values.yaml`:

```yaml
dagster:
  dagster:
    ingress:
      ingressClassName: internal-nginx
```

(this can also be done in the configuration tab of the plural console for your dagster app)