{{ $hostname := .Values.hostname }}
{{ $yataiHelmValues := .Applications.HelmValues "yatai" }}

You can view your installation at https://{{ $hostname}}
test {{ $yataiHelmValues.yatai.yatai.postgresql.host }}
