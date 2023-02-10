# Adding Data Catalogs

Trino doesn't come with a natural way to preconfigure datasources, but it's relatively easy to do through helm.  You simply need to edit `trino/helm/trino/values.yaml` and add something like:

```yaml
trino:
  additionalCatalogs:
    lakehouse.properties: |-
        connector.name=iceberg
        hive.metastore.uri=thrift://example.net:9083
    rdbms.properties: |-
        connector.name=postgresql
        connection-url=jdbc:postgresql://example.net:5432/database
        connection-user=root
        connection-password=secret
```

(note this is an encrypted file in your repo so safe to edit however you want).

In the console, you can simply use trino's configuration tab at Configuration -> Helm
