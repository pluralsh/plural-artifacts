Use `plural watch elasticsearch` to track the status of your application.  When it's fully provisioned, you can fetch the creds by running:

```
kubectl get secret elasticsearch-es-elastic-user -n elasticsearch -o yaml"
```

The connection info will be base64 decoded w/in the `data` field of the resulting secret. The username will always be `elastic`.

We also deploy a kibana instance available at {{ .Values.hostname }}


