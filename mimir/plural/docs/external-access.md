# Ship Metrics to Mimir from beyond this cluster

Mimir by default is deployed in a cluster local way.  The simplest way to enable external ingress is to set your install to use basic auth, which can be done via editing your `context.yaml` file with:


```yaml
configuration:
  mimir:
    hostname: mimir.<you-subdomain> # you can find the configured domain in `workspace.yaml`
    basicAuth:
      user: <username>
      password: <password2>
```
you can use `plural crypto random` to generate a high-entropy password if that is helpful as well.


Once that file has been edited, you can run `plural build --only mimir && plural deploy --commit "configure loki ingress"` to update your loki install.

We have often seen people use remote prometheus writes to ship metrics from a prometheus scraper to this centralized mimir instance.