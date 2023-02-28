 Your airbyte installation is available at https://{{ .Values.hostname }}

{{ if .OIDC }}
It looks like you've enabled OIDC!  Login will be managed by plural from now on,
feel free to add your teammembers in the OIDC configuration page in the plural UI.
{{ else }}
You did not enable OIDC for your airbyte install.  It will not be accessible publicly since airbyte OSS 
does not have native authentication support.  If you want, you can enable oidc be running the bundle install command,
eg:

```
plural bundle install airbyte airbyte-aws
plural build --only airbyte
plural deploy --commit "enable airbyte oidc"
```

(be sure to enable oidc at the end)
{{ end }}