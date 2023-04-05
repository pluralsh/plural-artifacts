Use `plural watch elasticsearch` to track the status of your application.  When it's fully provisioned, you can fetch the creds by running:

```
kubectl get secret elasticsearch-es-elastic-user -n elasticsearch -o go-template --template="{{.data.elastic | base64decode}}"
```

The username will always be `elastic`.

We also deploy a kibana instance available at {{ .Values.hostname }}


