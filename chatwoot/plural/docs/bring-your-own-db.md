## Connecting to a managed SQL instance

We ship chatwoot with the zalando postgres operator's db for persistence by default.  This provides a lot of the benefits of a managed postgres instance at a lower cost, but if you'd rather use a familiar service like RDS this is still possible.  You'll need to do a few things:

### save the database password to a secret

you can use a number of methods for this, but simply adding a secret file as `chatwoot/helm/chatwoot/templates/db-password.yaml` like:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: chatwoot-db-password
stringData:
  password: {{ .Values.externalDb.password }}
```

Note: this password needs to be in the `chatwoot` namespace.  If you put it in our wrapper helm chart, that will be done by default for you.

### modify chatwoot's helm values.yaml 

If you go to `chatwoot/helm/chatwoot/values.yaml` you'll need to provide credentials for postgres.  They should look something like:

```yaml
externalDb:
  password: <my password>
chatwoot:
  chatwoot:
    postgresql:
      enabled: false
      postgresqlHost: <YOUR_DB_HOSTNAME>
      postgresqlPort: 5432
      auth:
        database: <YOUR_DB_NAME>
        username: <YOUR_DB_NAME>
        existingSecret: chatwoot-db-password
        secretKeys:
            adminPasswordKey: password
```

(we're ultimately beholden to the structure defined in chatwoot's upstream helm chart here)

### redeploy

From there, you should be able to run `plural build --only chatwoot && plural deploy --commit "using existing postgres instance"` to use the managed sql instance