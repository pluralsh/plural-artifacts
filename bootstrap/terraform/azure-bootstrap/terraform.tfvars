{{- $tfOutput := pathJoin repoRoot "bootstrap" "output.yaml" }}
resource_group = {{ .Project | quote }}
name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}

{{- if fileExists $tfOutput }}
{{- $bootstrapOutputs := .Applications.TerraformValues "bootstrap" }}
{{- if $bootstrapOutputs }}

network_name = {{ $bootstrapOutputs.network.vnet_name | quote }}

{{- else }}

network_name = {{ .Values.network_name | quote }}

{{- end }}

{{- else }}

network_name = {{ .Values.network_name | quote }}

{{- end }}
