# Setting Up Your first clickhouse instance

This deploys a kubernetes operator which allows you to proivision as many clickhouse instances as you see fit. You'll need to create your instance of its crd, which you can add to `clickhouse/helm/clickhouse/templates`.  Here's an example yaml file to get you started:

```yaml
apiVersion: "clickhouse.altinity.com/v1"
kind: "ClickHouseInstallation"
metadata:
  name: "clickhouse"
spec:
  configuration:
    clusters:
    - name: "cluster"
      layout:
        shardsCount: 3
        replicasCount: 2
```

The operator is actually quite well documented, and you can dive deeper by checking out some of the examples here: https://github.com/Altinity/clickhouse-operator/tree/master/docs/chi-examples if you want a more sophisticated setup