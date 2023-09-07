vpc_name = {{ .Values.vpc_name | quote }}
cluster_name = {{ .Cluster | quote }}
{{- if eq .ClusterAPI true }}
create_cluster = false
enable_irsa = false
{{- end }}

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

{{- if .Values.worker_private_subnet_ids }}
worker_private_subnet_ids = {{ .Values.worker_private_subnet_ids | toJson }}
{{- end }}

{{- if .Values.disable_ebs_csi_driver }}
enable_ebs_csi_driver = false
{{- end }}
{{- if .Values.disable_cluster_autoscaler }}
enable_cluster_autoscaler = false
{{- end }}
{{- if .Values.disable_aws_lb_controller }}
enable_aws_lb_controller = false
{{- end }}

{{- if .BYOK }}
{{- if .BYOK.enabled }}
create_cluster = false
{{- end }}
{{- end }}
