# Bring Your Own Postgres DB

Some users might prefer to use and external or managed postgres instance rather than an on-cluster one.  In that case, only a small reconfiguration is required, in `umami/helm/umami/values.yaml` overlay the following:

```yaml
umami:
  postgres:
    enabled: false # if you'd like to remove the existing db
    dsn: 'postgresql://<user>:<password>@<host>:<port>/<db>'
```

You can use any valid postgres connection string, and might need to tweak sslmode and so forth to get the exact correct value.  This file will be encrypted, so no worries about secret exposure as well.

Once that reconfiguration has been made, simply run: `plural build --only umami && plural deploy --commit "redeploy umami"` to apply the changes on your cluster.