{{/*
Expand the name of the chart.
*/}}
{{- define "cluster-api-operator-plural.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cluster-api-operator-plural.fullname" -}}
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
{{- define "cluster-api-operator-plural.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cluster-api-operator-plural.labels" -}}
helm.sh/chart: {{ include "cluster-api-operator-plural.chart" . }}
{{ include "cluster-api-operator-plural.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cluster-api-operator-plural.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cluster-api-operator-plural.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cluster-api-operator-plural.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cluster-api-operator-plural.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create the name of the secret to use
*/}}
{{- define "cluster-api-operator-plural.secretName" -}}
{{- if .Values.secret.create }}
{{- default (include "cluster-api-operator-plural.fullname" .) .Values.secret.name }}
{{- else }}
{{- default "default" .Values.secret.name }}
{{- end }}
{{- end }}

{{/*
Create the aws credentials file
*/}}
{{- define "cluster-api-operator-plural.awsCredentialsFile" -}}
{{- if .Values.infrastructureProvider.aws.enabled -}}
[default]
aws_access_key_id = {{ .Values.infrastructureProvider.aws.bootstrapCredentials.AWS_ACCESS_KEY_ID }}
aws_secret_access_key = {{ .Values.infrastructureProvider.aws.bootstrapCredentials.AWS_SECRET_ACCESS_KEY }}
region = {{ .Values.infrastructureProvider.aws.secretData.AWS_REGION }}
{{- if .Values.infrastructureProvider.aws.bootstrapCredentials.AWS_SESSION_TOKEN }}
aws_session_token = {{ .Values.infrastructureProvider.aws.bootstrapCredentials.AWS_SESSION_TOKEN  }}
{{- end }}
{{- end -}}
{{- end -}}

{{/*
Return the b64 encoded aws credentials file depending on if bootstrap credentials should be used
*/}}
{{- define "cluster-api-operator-plural.awsCredentialsValue" -}}
{{- if .Values.secret.bootstrap -}}
{{- include "cluster-api-operator-plural.awsCredentialsFile" . | b64enc | quote -}}
{{- else -}}
{{ print "\"\"" | b64enc  }}
{{- end -}}
{{- end -}}
