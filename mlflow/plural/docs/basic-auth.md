## Configuring Basic Auth

Mlflows's api and web interface is not authenticated by default.  We provide an oauth proxy by default to grant some security to your mlflow install, but in order to integrate with tools like airflow, you'll likely want a means to authenticate with static creds.  That's where basic auth can be very useful. The process is fortunately simple.

### modify context.yaml

in the `context.yaml` file at the root of your repo, simply add:

```yaml
configuration:
  mlflow:
    users:
      <name>: <password>
      <name2>: <password2>
```
you can use `plural crypto random` to generate a high-entropy password if that is helpful as well.

### redeploy

Simply run `plural build --only mlflow && plural deploy --commit "enabling basic auth"` to wire in the credentials to our oauth proxy.  Occasionally you need to restart the web pods to get it to take, you can find them with:

```sh
kubectl get pods -n mlflow
```

the pods will look something like `mlflow-66ffb5d876-fq8ls` (random suffixes will vary).

then delete them (allowing k8s to restart) with:

```sh
kubectl delete pod <name> -n mlflow
```

### Access

From there you can either use a standard basic auth header to authenticate to your mlflow instance, or set the url as: `https://{user}:{password}@{your-mlflow-hostname}` in whatever code needs to call the mlflow api.

The mlflow python client also supports handling basic auth via a few custom env vars documented here: https://www.mlflow.org/docs/latest/tracking.html#logging-to-a-tracking-server