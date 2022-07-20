{{ $bootstrapOutputs := .Applications.TerraformValues "bootstrap" }}
namespace = {{ .Namespace | quote }}
pipelines_bucket = {{ .Values.pipelines_bucket | quote }}
cluster_name = {{ .Cluster | quote }}
node_role_arn = {{ (index $bootstrapOutputs.node_groups 0).node_role_arn | quote }}
private_subnets = yamldecode(<<EOT
{{ $bootstrapOutputs.cluster_worker_private_subnets | toYaml }}
EOT
)
