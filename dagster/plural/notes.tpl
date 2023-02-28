You can access your dagster instance at {{ .Values.hostname }}

{{ if not .OIDC }}
You did not enable OIDC for your dagster install.  It will not be accessible publicly since dagster OSS 
does not have native authentication support.  If you want, you can enable oidc be running the bundle install command,
eg:

```
plural bundle install dagster dagster-aws
plural build --only dagster
plural deploy --commit "enable dagster oidc"
```

(be sure to enable oidc at the end)
{{ end }}