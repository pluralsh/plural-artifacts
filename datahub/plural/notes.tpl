Use `plural watch datahub` to track the status of your application

You can view your datahub instance at https://{{ .Values.hostname }}

{{ if .OIDC }}
You've enabled Plural OIDC for your datahub instance.  Be sure to add more teammates in the plural UI.

After logging in with your Plural account, you will need to login with the datahub admin account to give yourself administrator privileges.

The url to login with the admin account is https://{{ .Values.hostname }}/login
The datahub admin credentials are:

username: datahub
password: {{ .datahub.adminPassword }}
{{ else }}
Your admin credentials are:

username: datahub
password: {{ .datahub.adminPassword }}
{{ end }}
