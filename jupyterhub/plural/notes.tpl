Your jupyterhub installation is available at https://{{ .Values.hostname }}

{{ if .OIDC }}
Your jupyterhub has been configured with OAuth against your plural account!
{{ else }}
You are using standard username/password authentication, so user management will be manual. We strongly recommend
you consider installing with OIDC enabled
{{ end }}