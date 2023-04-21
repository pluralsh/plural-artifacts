# Add Your Own User Code Deployment

Dagster has a concept of user code deployments which allow you to specify multiple independent repositories of dags to register with the same dagster orchestrator.  This is a great way to separate dependency trees between codebases or manage a complex data org.  An example user code deployment configuration can be seen here:

```yaml
dagster:
  dagster:
    dagster-user-deployments:
      deployments:
      - dagsterApiGrpcArgs:
        - -m
        - dags
        envSecrets:
        - name: dagster-user-secrets # if you want to add env vars from a k8s secret
        image:
          pullPolicy: Always
          repository: ghcr.io/your/dagster-code
          tag: v0.0.4
        name: dags
        port: 4000
        resources:
          requests:
            cpu: 20m
            memory: 100Mi
      imagePullSecrets:
      - name: gh-creds # additional pull credentials if you would like to use then
```

It can be a bit tedious to manually maintain this configuration as your codebase, so we've provided the `plural upgrade` command to automate this out of CI.  Here's an example github action doing just that: https://github.com/pluralsh/dagster-example/blob/main/.github/workflows/publish.yml#L49. The `upgrade.yaml` file it references can be seen here: https://github.com/pluralsh/dagster-example/blob/main/upgrade.yaml

