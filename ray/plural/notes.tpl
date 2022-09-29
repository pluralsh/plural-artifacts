Use `plural watch ray` to track the status of your application

Your Ray dashboard is available at https://{{ .Values.hostname }}

{{- if .OIDC }}
It looks like you've enabled OIDC!  Login will be managed by plural from now on,
feel free to add your teammembers on the OIDC configuration page in the plural UI.
{{- else }}
The Ray dashboard has no built-in authentication. It is strongly recommended to enable OIDC.
This can be done on the OIDC configuration page in the plural UI.
{{- end }}
