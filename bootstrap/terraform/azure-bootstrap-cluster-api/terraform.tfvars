{{- $tfOutput := pathJoin repoRoot "bootstrap" "output.yaml" }}
resource_group = {{ .Project | quote }}
name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
cluster_api = {{ .ClusterAPI }}

{{- if fileExists $tfOutput }}
{{- $bootstrapOutputs := .Applications.TerraformValues "bootstrap" }}
{{- if $bootstrapOutputs }}

network_name = {{ $bootstrapOutputs.network.vnet_name | quote }}
subnet_prefixes = yamldecode(<<EOT
{{ (index $bootstrapOutputs.network.vnet_subnets_raw 0).address_prefixes | toYaml }}
EOT
)

{{- if $bootstrapOutputs.cluster.cluster_raw.linux_profile }}
admin_username = {{ (index $bootstrapOutputs.cluster.cluster_raw.linux_profile 0).admin_username | quote }}
{{- end }}

{{- else }}

network_name = {{ .Values.network_name | quote }}

{{- end }}

{{- else }}

network_name = {{ .Values.network_name | quote }}

{{- end }}
