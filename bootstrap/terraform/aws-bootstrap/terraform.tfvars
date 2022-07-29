vpc_name = {{ .Values.vpc_name | quote }}
cluster_name = {{ .Cluster | quote }}

map_roles = [
  {
    rolearn = "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-console"
    username = "console"
    groups = ["system:masters"]
  }
]


{{- if .Values.database_subnets }}
database_subnets = yamldecode(<<EOT
{{ .Values.database_subnets | toYaml }}
EOT
)
{{- end }}
