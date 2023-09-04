{{/*
Expand the name of the chart.
*/}}
{{- define "cluster-api-cluster.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cluster-api-cluster.fullname" -}}
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
{{- define "cluster-api-cluster.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cluster-api-cluster.labels" -}}
helm.sh/chart: {{ include "cluster-api-cluster.chart" . }}
{{ include "cluster-api-cluster.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cluster-api-cluster.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cluster-api-cluster.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cluster-api-cluster.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cluster-api-cluster.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Creates the Kubernetes version for the cluster
# TODO: this should actually be used to sanatize the `.Values.cluster.kubernetesVersion` value to what the providers support instead of defining these static versions
*/}}
{{- define "cluster.kubernetesVersion" -}}
{{- if eq .Values.provider "aws" -}}
v1.24
{{- end }}
{{- if eq .Values.provider "azure" -}}
v1.25.11
{{- end }}
{{- if and (eq .Values.provider "gcp") (eq .Values.type "managed") -}}
1.24.14-gke.2700
{{- end }}
{{- if eq .Values.provider "kind" -}}
v1.25.11
{{- end }}
{{- end }}

{{/*
Create the kind for the infrastructureRef for the cluster
*/}}
{{- define "cluster.infrastructure.kind" -}}
{{- if and (eq .Values.provider "aws") (eq .Values.type "managed") -}}
AWSManagedCluster
{{- end }}
{{- if and (eq .Values.provider "azure") (eq .Values.type "managed") -}}
AzureManagedCluster
{{- end }}
{{- if and (eq .Values.provider "gcp") (eq .Values.type "managed") -}}
GCPManagedCluster
{{- end }}
{{- if and (eq .Values.provider "kind") (eq .Values.type "managed") -}}
DockerCluster
{{- end }}
{{- end }}

{{/*
Create the apiVersion for the infrastructureRef for the cluster
*/}}
{{- define "cluster.infrastructure.apiVersion" -}}
{{- if and (eq .Values.provider "aws") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta2
{{- end }}
{{- if and (eq .Values.provider "azure") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- if and (eq .Values.provider "gcp") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- if and (eq .Values.provider "kind") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- end }}

{{/*
Create the kind for the controlPlaneRef for the cluster
*/}}
{{- define "cluster.controlPlane.kind" -}}
{{- if and (eq .Values.provider "aws") (eq .Values.type "managed") -}}
AWSManagedControlPlane
{{- end }}
{{- if and (eq .Values.provider "azure") (eq .Values.type "managed") -}}
AzureManagedControlPlane
{{- end }}
{{- if and (eq .Values.provider "gcp") (eq .Values.type "managed") -}}
GCPManagedControlPlane
{{- end }}
{{- if and (eq .Values.provider "kind") (eq .Values.type "managed") -}}
KubeadmControlPlane
{{- end }}
{{- end }}

{{/*
Create the apiVersion for the controlPlaneRef for the cluster
*/}}
{{- define "cluster.controlPlane.apiVersion" -}}
{{- if and (eq .Values.provider "aws") (eq .Values.type "managed") -}}
controlplane.cluster.x-k8s.io/v1beta2
{{- end }}
{{- if and (eq .Values.provider "azure") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- if and (eq .Values.provider "gcp") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- if and (eq .Values.provider "kind") (eq .Values.type "managed") -}}
controlplane.cluster.x-k8s.io/v1beta1
{{- end }}
{{- end }}

{{/*
Create the kind for the infrastructureRef for the worker MachinePools
*/}}
{{- define "workers.infrastructure.kind" -}}
{{- if and (eq .Values.provider "aws") (eq .Values.type "managed") -}}
AWSManagedMachinePool
{{- end }}
{{- if and (eq .Values.provider "azure") (eq .Values.type "managed") -}}
AzureManagedMachinePool
{{- end }}
{{- if and (eq .Values.provider "gcp") (eq .Values.type "managed") -}}
GCPManagedMachinePool
{{- end }}
{{- if and (eq .Values.provider "kind") (eq .Values.type "managed") -}}
DockerMachinePool
{{- end }}
{{- end }}

{{/*
Create the apiVersion for the infrastructureRef for the worker MachinePools
*/}}
{{- define "workers.infrastructure.apiVersion" -}}
{{- if and (eq .Values.provider "aws") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta2
{{- end }}
{{- if and (eq .Values.provider "azure") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- if and (eq .Values.provider "gcp") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- if and (eq .Values.provider "kind") (eq .Values.type "managed") -}}
infrastructure.cluster.x-k8s.io/v1beta1
{{- end }}
{{- end }}

{{/*
Create the configRef for the worker MachinePools
*/}}
{{- define "workers.configref" -}}
{{- if and (eq .Values.provider "kind") (eq .Values.type "managed") -}}
configRef:
  apiVersion: bootstrap.cluster.x-k8s.io/v1beta1
  kind: KubeadmConfig
  name: worker-mp-config
{{- end }}
{{- end }}

{{/*
Create a MachinePool for the given values
  ctx = . context
  name = the name of the MachinePool resource
  values = the values for this specific MachinePool resource
  defaultVals = the default values for the MachinePool resource
*/}}
{{- define "workers.machinePool" -}}
{{- $replicas := (.values | default dict).replicas | default .defaultVals.replicas }}
apiVersion: cluster.x-k8s.io/v1beta1
kind: MachinePool
metadata:
  name: {{ .name }}
  annotations:
    helm.sh/resource-policy: keep
spec:
  clusterName: {{ .ctx.Values.cluster.name }}
  replicas: {{ $replicas }}
  template:
    spec:
      {{- if or (eq .ctx.Values.provider "gcp") (eq .ctx.Values.provider "azure") (eq .ctx.Values.provider "kind") }}
      version: {{ .values.kubernetesVersion | default (include "cluster.kubernetesVersion" .ctx) }}
      {{- end }}
      clusterName: {{ .ctx.Values.cluster.name }}
      bootstrap:
        {{- if or (eq .ctx.Values.provider "gcp") (eq .ctx.Values.provider "azure") (eq .ctx.Values.provider "aws") }}
        dataSecretName: ""
        {{- end }}
        {{- if eq .ctx.Values.provider "kind" }}
        {{- include "workers.configref" .ctx | nindent 8 }}
        {{- end }}
      infrastructureRef:
        name: {{ .name }}
        apiVersion: {{ include "workers.infrastructure.apiVersion" .ctx }}
        kind: {{ include "workers.infrastructure.kind" .ctx }}
{{- end }}
