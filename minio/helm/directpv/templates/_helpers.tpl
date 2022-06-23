{{/*
Expand the name of the chart.
*/}}
{{- define "directpv.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "directpv.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "directpv.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "directpv.labels" -}}
helm.sh/chart: {{ include "directpv.chart" . }}
application-name: direct.csi.min.io
application-type: CSIDriver
direct.csi.min.io/created-by: kubectl-direct-csi
direct.csi.min.io/version: v1beta4
{{ include "directpv-common.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "directpv-common.selectorLabels" -}}
app.kubernetes.io/instance: {{ .Release.Name }}
selector.direct.csi.min.io.webhook: enabled
{{- end }}


{{/*
Selector labels
*/}}
{{- define "directpv-deployment.selectorLabels" -}}
app.kubernetes.io/name: {{ include "directpv.name" . }}-deployment
{{ include "directpv-common.selectorLabels" . }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "directpv-daemonset.selectorLabels" -}}
app.kubernetes.io/name: {{ include "directpv.name" . }}-daemonset
{{ include "directpv-common.selectorLabels" . }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "directpv.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "directpv.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}
