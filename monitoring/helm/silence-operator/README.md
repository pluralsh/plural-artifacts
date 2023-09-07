# silence-operator

Deploys the alertmanager silence operator to allow for CRD managed alert silences.  You can specify any silences you might want to add using in your installations `values.yaml` file:

```yaml
silence-operator:
  silences:
    <name>:
        matchers:
        - name: alertname
          value: <Alertname>
          regex: false
```