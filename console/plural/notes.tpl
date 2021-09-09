You can view your installation at https://{{ .Values.console_dns }}

{{ if .OIDC }}
It looks like you've enabled OIDC!  Login will be managed by plural from now on,
feel free to add your teammembers in the OIDC configuration page in the plural UI.
{{ else }}
Your initial admin credentials are:

Email: {{ .Values.admin_email }}
Password: {{ .console.secrets.admin_password }}

It's strongly recommended to rotate this password immediately if you intend to share this repository.
{{ end }}