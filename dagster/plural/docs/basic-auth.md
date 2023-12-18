## Configuring Basic Auth

Dagster's api and web interface is not authenticated by default.  We provide an oauth proxy by default to grant some security to your dagster install, but in order to integrate with tools like airflow, you'll likely want a means to authenticate with static creds.  That's where basic auth can be very useful.  The process is very simple.

### modify context.yaml

in the `context.yaml` file at the root of your repo, simply add:

```yaml
configuration:
  dagster:
    users:
      <name>: <password>
      <name2>: <password2>
```
you can use `plural crypto random` to generate a high-entropy password if that is helpful as well.

### redeploy

Simply run `plural build --only dagster && plural deploy --commit "enabling basic auth"` to wire in the credentials to our oauth proxy.  Occasionally you need to restart the web pods to get it to take, you can find them with:

```sh
kubectl get pods -n dagster | grep dagster-webserver
```

then delete them (allowing k8s to restart) with:

```sh
kubectl delete pod <name> -n dagster
```