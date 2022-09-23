 Your touca installation is available at https://{{ .Values.hostname }}

{{ if .OIDC }}
It looks like you've enabled OIDC!  Login will be managed by plural from now on,
feel free to add your teammembers in the OIDC configuration page in the plural UI.
{{ end }}
