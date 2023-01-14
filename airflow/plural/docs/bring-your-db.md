## Connecting to a managed SQL instance

We ship airbyte with the zalando postgres operator's db for persistence by default.  This provides a lot of the benefits of a managed postgres instance at a lower cost, but if you'd rather use a familiar service like RDS this is still possible.  You'll need to do a few things:

### edit context.yaml

At the root of the repo, edit the `context.yaml` field and set `configuration.airflow.postgresDisabled: true`, this will allow us to reconfigure airflow for bring-your-own-db.

### save the database password to a secret

you can use a number of methods for this, but simply adding a secret file as `airflow/helm/airflow/templates/db-password.yaml` like:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: airflow-db-password
stringData:
  password: {{ .Values.externalDb.password }}
```

Note: this password needs to be in the `airflow` namespace.  If you put it in our wrapper helm chart, that will be done by default for you.

### modify airflow's helm values.yaml 

If you go to `airflow/helm/airflow/values.yaml` you'll need to provide credentials for postgres.  They should look something like:

```yaml
externalDb:
  password: <my password>
airflow:
  airflow:
    externalDatabase:
      database: <YOUR_DB_NAME>
      host: <YOUR_DB_URL>
      passwordSecret: airflow-db-password
      passwordSecretKey: password
      user: <YOU_DB_USER>
      port: 5432

      # use this for any extra connection-string settings, e.g. ?sslmode=disable
      properties: "?sslmode=allow"
```

### redeploy

From there, you should be able to run `plural build && plural deploy --commit "using existing postgres instance"` to use the managed sql instance