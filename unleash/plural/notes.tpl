Your unleash installation is available at https://{{ .Values.hostname }}
{{ if .OIDC }}
Your directus has been configured with OAuth against your plural account!
{{ else }}
You are using standard username/password authentication, so user management will be manual.
The default login is admin/unleash4all. We recommend to change it at https://{{ .Values.hostname }}/profile/change-password
We strongly recommend that you consider installing with OIDC enabled.
{{ end }}
