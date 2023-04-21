## Adding grafana plugins to your install

you can simply add to `grafana/helm/grafana/values.yaml` or in grafana's configuration page in your plural console:

```yaml
grafana:
  grafana:
    plugins:
    - your-plugin-name
```