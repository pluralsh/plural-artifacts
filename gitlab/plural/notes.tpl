You can view your gitlab instance at https://gitlab.{{ .Network.Subdomain }}

{{ if .OIDC }}
You've enabled Plural OIDC for authentication, so be sure to add your teammembers
to the installation in the plural web UI.
{{ end }}

Your root password is {{ .gitlab.rootPassword }}