You can view your sentry instance at https://{{ .Values.hostname }}

{{ if .OIDC }}
You've enabled Plural OIDC for your sentry instance.  Be sure to add more teammates in the plural UI.
Please see the application docs on Plural that describes how to enable OIDC inside sentry.
{{ end }}

Your initial admin credentials are:

username: {{ .Values.adminEmail }}
password: {{ .sentry.sentry.user.password }}
