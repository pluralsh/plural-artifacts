Your directus installation is available at https://{{ .Values.hostname }}

{{ if .OIDC }}
Your directus has been configured with OAuth against your plural account!
{{ else }}
You are using standard username/password authentication, so user management will be manual via the ADMIN_EMAIL and ADMIN_PASSWORD environment variables.
We strongly recommend that you consider installing with OIDC enabled.
{{ end }}