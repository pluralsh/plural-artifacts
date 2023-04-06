{{/*
Expand the name of the chart.
*/}}
{{- define "trace-shield.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "trace-shield.fullname" -}}
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
{{- define "trace-shield.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "trace-shield.labels" -}}
helm.sh/chart: {{ include "trace-shield.chart" . }}
{{ include "trace-shield.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "trace-shield.selectorLabels" -}}
app.kubernetes.io/name: {{ include "trace-shield.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Backend selector labels
*/}}
{{- define "trace-shield.backendSelectorLabels" -}}
app.kubernetes.io/name: {{ include "trace-shield.name" . }}-backend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Frontend selector labels
*/}}
{{- define "trace-shield.frontendSelectorLabels" -}}
app.kubernetes.io/name: {{ include "trace-shield.name" . }}-frontend
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Controller selector labels
*/}}
{{- define "trace-shield.controllerSelectorLabels" -}}
app.kubernetes.io/name: {{ include "trace-shield.name" . }}-controller
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "trace-shield.backendServiceAccountName" -}}
{{- if .Values.backend.serviceAccount.create }}
{{- default (include "trace-shield.fullname" .) .Values.backend.serviceAccount.name }}-backend
{{- else }}
{{- default "default" .Values.backend.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "trace-shield.frontendServiceAccountName" -}}
{{- if .Values.frontend.serviceAccount.create }}
{{- default (include "trace-shield.fullname" .) .Values.frontend.serviceAccount.name }}-frontend
{{- else }}
{{- default "default" .Values.frontend.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "trace-shield.controllerServiceAccountName" -}}
{{- if .Values.controller.serviceAccount.create }}
{{- default (include "trace-shield.fullname" .) .Values.controller.serviceAccount.name }}-controller
{{- else }}
{{- default "default" .Values.controller.serviceAccount.name }}
{{- end }}
{{- end }}
