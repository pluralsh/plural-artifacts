# Ship Logs to Loki from beyond this cluster

Loki by default is deployed in a cluster local way.  The simplest way to enable external ingress is to set your install to use basic auth, which can be done via editing your `context.yaml` file with:


```yaml
configuration:
  loki:
    hostname: loki.<you-subdomain> # you can find the configured domain in `workspace.yaml`
    basicAuth:
      user: <username>
      password: <password2>
```
you can use `plural crypto random` to generate a high-entropy password if that is helpful as well.


Once that file has been edited, you can run `plural build --only loki && plural deploy --commit "configure loki ingress"` to update your loki install.