{{ .Configuration }}
{{ $hostname := .Values.hostname }}
{{ $yataiHelmValues := .Applications.HelmValues "yatai" }}

Use `plural watch yatai` to track the status of your application

You can view your installation at https://{{ $hostname}}
test {{ $yataiHelmValues.yatai.yatai.postgresql.host }}
