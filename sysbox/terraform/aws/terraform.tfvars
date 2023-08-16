{{- $bootstrap := .Applications.TerraformValues "bootstrap" -}}

namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
private_subnets = yamldecode(<<EOT
{{ $bootstrap.cluster_worker_private_subnets | toYaml }}
EOT
)
