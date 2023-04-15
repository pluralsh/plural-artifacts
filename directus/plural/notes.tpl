Your directus installation is available at https://{{ .Values.hostname }}

Your initial admin credentials are:
Email: {{ .Values.adminEmail }}
Password: {{ .directus.directus.admin.password }}

{{ if .OIDC }}
Your directus has been configured with OAuth against your plural account!
{{ else }}
You are using standard username/password authentication, so user management will be manual.
We strongly recommend that you consider installing with OIDC enabled.
{{ end }}