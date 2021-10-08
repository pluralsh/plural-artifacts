You can view your grafana instance at https://{{ .Values.hostname }}

{{ if .OIDC }}
You've enabled Plural OIDC for your grafana instance.  Be sure to add more teammates in the plural UI.

After logging in with your Plural account, you will need to login with the Grafana admin account to give yourself administrator privileges.
The grafana admin credentials are:

username: admin
password: {{ .Configuration.grafana.admin.password }}
{{ else }}
Your initial admin credentials are:

username: admin
password: {{ .Configuration.grafana.admin.password }}
{{ end }}
