{{- $bootstrap := .Applications.TerraformValues "bootstrap" -}}

namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
node_role_arn = {{ (index $bootstrap.node_groups 0).node_role_arn | quote }}
private_subnets = yamldecode(<<EOT
{{ $bootstrap.cluster_worker_private_subnets | toYaml }}
EOT
)
