Your directus installation is available at https://{{ .Values.hostname }}

Your initial admin credentials are:
Email: {{ .Values.adminEmail }}
Password: {{ .directus.directus.admin.password }}

{{ if .OIDC }}
Your directus has been configured with OAuth against your plural account!
Note that OIDC users will have to be assigned a role manually using the admin credentials.
{{ else }}
You are using standard username/password authentication, so user management will be manual.
We strongly recommend that you consider installing with OIDC enabled.
{{ end }}