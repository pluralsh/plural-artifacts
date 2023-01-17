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

aws_region = {{ .Region | quote }}
{{- if .Values.disable_ebs_csi_driver }}
enable_ebs_csi_driver = false
{{- end }}

{{- if .BYOK }}
{{- if .BYOK.enabled }}
create_cluster = false
{{- end }}
{{- end }}
