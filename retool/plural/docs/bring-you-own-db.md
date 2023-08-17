## Connecting to a managed SQL instance

We ship retool with the zalando postgres operator's db for persistence by default.  This provides a lot of the benefits of a managed postgres instance at a lower cost, but if you'd rather use a familiar service like RDS this is still possible.  You'll need to do a few things:

### save the database password to a secret

you can use a number of methods for this, but simply adding a secret file as `retool/helm/retool/templates/db-password.yaml` like:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: retool-db-password
stringData:
  password: {{ .Values.externalDb.password }}
```

Note: this password needs to be in the `retool` namespace.  If you put it in our wrapper helm chart, that will be done by default for you.

### modify retool's helm values.yaml 

If you go to `retool/helm/retool/values.yaml` you'll need to provide credentials for postgres.  They should look something like:

```yaml
externalDb:
  password: <my password>
retool:
  retool:
    config:
      postgres:
        host: <YOUR_DB_HOSTNAME>
        port: 5432
        db: <YOUR_DB_NAME>
        user: <YOUR_DB_USER>
        passwordSecretName: retool-db-password
        passwordSecretKey: password
        ssl_enabled: true
```

(we're ultimately beholden to the structure defined in retool's upstream helm chart here)

### redeploy

From there, you should be able to run `plural build --only retool && plural deploy --commit "using existing postgres instance"` to use the managed sql instance