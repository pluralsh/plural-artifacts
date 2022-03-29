{{- $bootstrapOutputs := .Applications.TerraformValues "bootstrap" }}
gcp_project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
vpc_name_prefix = {{ .Values.vpc_name | quote }}
externaldns_sa_name = "{{ .Cluster }}-externaldns"
gcp_region = {{ .Region | quote }}
{{- if $bootstrapOutputs }}
network_policy_enabled = {{ $bootstrapOutputs.cluster.network_policy_enabled }}
datapath_provider = {{ $bootstrapOutputs.cluster.datapath_provider | quote }}
{{- else }}
network_policy_enabled = false
datapath_provider = "ADVANCED_DATAPATH"
{{- end }}
