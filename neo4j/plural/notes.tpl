Use `plural watch neo4j` to track the status of your application.
When it's fully provisioned, you can browse https://{{ .Values.hostname }} and fetch the creds by running:

```
kubectl get secret neo4j-auth -n neo4j -o go-template='{{ .data.NEO4J_AUTH | base64decode }}'
```
