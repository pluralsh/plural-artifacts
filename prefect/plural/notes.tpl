Use `plural watch prefect` to track the status of your application

{{ if .OIDC }}
It looks like you've enabled OIDC!  Login will be managed by plural from now on,
feel free to add your teammembers in the OIDC configuration page in the plural UI.
{{ else }}
You did not enable OIDC for your prefect install.  It will not be accessible publicly since prefect OSS 
does not have native authentication support.  If you want, you can enable oidc by running the bundle install command,
eg:

```
plural bundle install prefect
plural build --only prefect
plural deploy --commit "enable prefect oidc"
```

(be sure to enable oidc at the end)
{{ end }}

{{- if .Values.users }}
It looks like you've also configured basic auth for your prefect instance, the credentials are as followed:

{{- range $user, $pwd := .Values.users }}
User: {{ $user }}
Password: {{ $pwd }}
{{- end }}

{{- end}}