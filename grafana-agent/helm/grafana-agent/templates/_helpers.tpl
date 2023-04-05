{{/*
Expand the name of the chart.
*/}}
{{- define "grafana-agent-plural.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "grafana-agent-plural.fullname" -}}
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
{{- define "grafana-agent-plural.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "grafana-agent-plural.labels" -}}
helm.sh/chart: {{ include "grafana-agent-plural.chart" . }}
{{ include "grafana-agent-plural.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "grafana-agent-plural.selectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana-agent-plural.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Metrics selector labels
*/}}
{{- define "grafana-agent-plural.metricsSelectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana-agent-plural.name" . }}-metrics
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Logs selector labels
*/}}
{{- define "grafana-agent-plural.logsSelectorLabels" -}}
app.kubernetes.io/name: {{ include "grafana-agent-plural.name" . }}-logs
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "grafana-agent-plural.serviceAccountName" -}}
{{- if .Values.agent.serviceAccount.create }}
{{- default (include "grafana-agent-plural.fullname" .) .Values.agent.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.agent.serviceAccount.name }}
{{- end }}
{{- end }}
