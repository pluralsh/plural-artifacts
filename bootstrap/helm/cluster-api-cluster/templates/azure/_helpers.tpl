{{/*
Name of the AzureClusterIdentity used for bootstrapping
*/}}
{{- define "azure-bootstrap.cluster-identity-name" -}}
{{- printf "%s-azure-bootstrap-identity" .Release.Name | trunc 63 }}
{{- end }}

{{/*
Name of the secret for the AzureClusterIdentity used for bootstrapping
*/}}
{{- define "azure-bootstrap.identity-credentials" -}}
{{- printf "%s-azure-bootstrap-credentials" .Release.Name | trunc 63 }}
{{- end }}

{{/*
Name of the AAD Pod Identity used for bootstrapping
*/}}
{{- define "azure-bootstrap.pod-identity-name" -}}
{{- printf "%s-%s-%s" .Values.cluster.name .Release.Namespace (include "azure-bootstrap.cluster-identity-name" .) }}
{{- end }}

{{/*
Name of the AAD Pod Identity Binding used for bootstrapping
*/}}
{{- define "azure-bootstrap.pod-identity-binding" -}}
{{- printf "%s-binding" (include "azure-bootstrap.pod-identity-name" .) }}
{{- end }}
