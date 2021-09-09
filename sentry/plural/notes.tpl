You can view your grafana instance at https://{{ .Values.hostname }}

{{ if .OIDC }}
You've enabled Plural OIDC for your sentry instance.  Be sure to add more teammates in the plural UI.
{{ else }}
Your initial admin credentials are:

username: {{ .Values.adminEmail }}
password: {{ .sentry.sentry.user.password }}
{{ end }}