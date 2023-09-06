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

{{/*
Function to template an AzureManagedMachinePool resource.
Params:
  ctx = . context
  name = the name of the AzureManagedMachinePool resource
  defaultVals = the default values for the AzureManagedMachinePool resource
  values = the values for this specific AzureManagedMachinePool resource
  availabilityZones = the availability zones for the AzureManagedMachinePool
*/}}
{{- define "workers.azure.managedMachinePool" -}}
{{- $scaling := (.values.spec | default dict).scaling | default .defaultVals.spec.scaling }}
{{- if $scaling }}
{{- if not (and (hasKey $scaling "minSize") (hasKey $scaling "maxSize")) }}
  {{- fail (printf "Invalid value for scaling. Both minSize and maxSize must be set") }}
{{- end }}
{{- end }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: AzureManagedMachinePool
metadata:
  annotations:
    helm.sh/resource-policy: keep
    {{- if (hasKey .values "annotations") -}}
    {{- toYaml (merge .values.annotations .defaultVals.annotations)| nindent 4 }}
    {{- else -}}
    {{- toYaml .defaultVals.annotations | nindent 4 }}
    {{- end }}
  labels:
    {{- if (hasKey .values "labels") -}}
    {{- toYaml (merge .values.labels .defaultVals.labels)| nindent 4 }}
    {{- else -}}
    {{- toYaml .defaultVals.labels | nindent 4 }}
    {{- end }}
  name: {{ .name }}
spec:
  name: {{ .name }}
  additionalTags:
    {{- if (dig "spec" "additionalTags" .values) -}}
    {{- toYaml (merge .values.spec.additionalTags .defaultVals.spec.additionalTags)| nindent 4 }}
    {{- else }}
    {{- toYaml .defaultVals.spec.additionalTags | nindent 4 }}
    {{- end }}
  mode: {{ (.values.spec | default dict).mode | default .defaultVals.spec.mode }}
  sku: {{ (.values.spec | default dict).sku | default .defaultVals.spec.sku }}
  osDiskSizeGB: {{ (.values.spec | default dict).osDiskSizeGB | default .defaultVals.spec.osDiskSizeGB }}
  availabilityZones: {{- toYaml .availabilityZones | nindent 2 }}
  nodeLabels:
    {{- if (dig "spec" "nodeLabels" .values) -}}
    {{- toYaml (merge .values.spec.nodeLabels .defaultVals.spec.nodeLabels)| nindent 4 }}
    {{- else -}}
    {{- toYaml .defaultVals.spec.nodeLabels | nindent 4 }}
    {{- end }}
  {{- if or (.defaultVals.spec.taints) ((.values.spec | default dict).taints) }}
  taints:
  {{- toYaml ((.values.spec | default dict).taints | default .defaultVals.spec.taints) | nindent 2 }}
  {{- end }}
  {{- if $scaling }}
  scaling:
    {{- toYaml $scaling | nindent 4 }}
  {{- end }}
  {{- if or (.defaultVals.spec.scaleDownMode) ((.values.spec | default dict).scaleDownMode) }}
  scaleDownMode: {{ (.values.spec | default dict).scaleDownMode | default .defaultVals.spec.scaleDownMode }}
  {{- end }}
  {{- if or (.defaultVals.spec.spotMaxPrice) ((.values.spec | default dict).spotMaxPrice) }}
  spotMaxPrice: {{ (.values.spec | default dict).spotMaxPrice | default .defaultVals.spec.spotMaxPrice }}
  {{- end }}
  maxPods: {{ (.values.spec | default dict).maxPods | default .defaultVals.spec.maxPods }}
  osDiskType: {{ (.values.spec | default dict).osDiskType | default .defaultVals.spec.osDiskType }}
  {{- if or (.defaultVals.spec.scaleSetPriority) ((.values.spec | default dict).scaleSetPriority) }}
  scaleSetPriority: {{ (.values.spec | default dict).scaleSetPriority | default .defaultVals.spec.scaleSetPriority }}
  {{- end }}
  osType: {{ (.values.spec | default dict).osType | default .defaultVals.spec.osType }}
  enableNodePublicIP: {{ (.values.spec | default dict).enableNodePublicIP | default .defaultVals.spec.enableNodePublicIP }}
  nodePublicIPPrefixID: {{ (.values.spec | default dict).nodePublicIPPrefixID | default .defaultVals.spec.nodePublicIPPrefixID }}
  {{- if or (.defaultVals.spec.kubeletConfig) ((.values.spec | default dict).kubeletConfig) }}
  kubeletConfig:
    {{- toYaml ((.values.spec | default dict).kubeletConfig | default .defaultVals.spec.kubeletConfig) | nindent 2 }}
  {{- end }}
  {{- if or (.defaultVals.spec.linuxOSConfig) ((.values.spec | default dict).linuxOSConfig) }}
  linuxOSConfig:
    {{- toYaml ((.values.spec | default dict).linuxOSConfig | default .defaultVals.spec.linuxOSConfig) | nindent 2 }}
  {{- end }}
---
{{- include "workers.machinePool" (dict "ctx" .ctx "name" .name "values" .values "defaultVals" .defaultVals) }}
{{- end }}
