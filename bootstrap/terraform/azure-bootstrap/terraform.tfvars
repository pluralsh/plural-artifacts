{{- $tfOutput := pathJoin repoRoot "bootstrap" "output.yaml" }}
resource_group = {{ .Project | quote }}
name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}

{{- if fileExists $tfOutput }}
{{- $bootstrapOutputs := .Applications.TerraformValues "bootstrap" }}
{{- if $bootstrapOutputs }}

network_name = {{ $bootstrapOutputs.network.vnet_name | quote }}
subnet_prefixes = [{{ (index $bootstrapOutputs.network.vnet_subnets_raw 0).address_prefix | quote }}]
admin_username = {{ (index $bootstrapOutputs.cluster.cluster_raw.linux_profile 0).admin_username | quote }}

{{- else }}

network_name = {{ .Values.network_name | quote }}

{{- end }}

{{- else }}

network_name = {{ .Values.network_name | quote }}

{{- end }}
