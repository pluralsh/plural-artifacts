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

## Connection Setup

To authenticate to your mimir instance from a remote metric shipper, you'll need to add two headers:

```
Authentication: Basic b64(<user>:<password>)
X-Scope-OrgID: <Cluster Name>
```

You'll need to base64 encode the username:password pair, which can be done with `echo $user:$password | base64`.  Since we set up mimir with multi-tenancy, you'll need to add an `X-Scope-OrgID` with a tenant header, which the default global tenant is just the name of your plural cluster found in `workspace.yaml`
