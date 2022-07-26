global:
  application:
    links:
    - description: openmetadata web ui
      url: {{ .Values.hostname }}
  elasticsearch:
    host: elasticsearch-es-http.{{ namespace "elasticsearch" }}

elasticNamespace: {{ namespace "elasticsearch" }}

{{- if eq .Provider "aws" }}
serviceAccount:
  annotations:
    eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-mysql-operator"
{{- end }}