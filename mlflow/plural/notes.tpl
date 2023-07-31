 You can view your installation at https://{{ .Values.hostname }}

 See https://github.com/pluralsh/mlflow-on-k8s-example for example usage.


{{- if .Values.users }}
It looks like you've also configured basic auth for your mlflow instance, the credentials are as followed:

{{- range $user, $pwd := .Values.users }}
User: {{ $user }}
Password: {{ $pwd }}
{{- end }}

{{- end}}