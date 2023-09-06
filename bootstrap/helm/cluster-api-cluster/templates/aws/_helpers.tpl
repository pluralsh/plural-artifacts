{{/*
Function to template an AWSManagedMachinePool resource.
Params:
  ctx = . context
  name = the name of the AWSManagedMachinePool resource
  defaultVals = the default values for the AWSManagedMachinePool resource
  values = the values for this specific AWSManagedMachinePool resource
  availabilityZones = the availability zones for the AWSManagedMachinePool
*/}}
{{- define "workers.aws.managedMachinePool" -}}
{{- $validAmiTypes := (list "AL2_x86_64" "AL2_x86_64_GPU" "AL2_ARM_64") -}}
{{- $validCapacityTypes := (list "onDemand" "spot") -}}
{{- $amiType := (.values.spec | default dict).amiType | default .defaultVals.spec.amiType }}
{{- if not (has $amiType $validAmiTypes) }}
  {{- fail (printf "Invalid value for amiType: %s. Expected one of: %s" $amiType $validAmiTypes) }}
{{- end }}
{{- $capacityType := (.values.spec | default dict).capacityType | default .defaultVals.spec.capacityType }}
{{- if not (has $capacityType $validCapacityTypes) }}
  {{- fail (printf "Invalid value for capacityType: %s. Expected one of: %s" $capacityType $validCapacityTypes) }}
{{- end }}
{{- $scaling := (.values.spec | default dict).scaling | default .defaultVals.spec.scaling }}
{{- if $scaling }}
{{- if not (and (hasKey $scaling "minSize") (hasKey $scaling "maxSize")) }}
  {{- fail (printf "Invalid value for scaling. Both minSize and maxSize must be set") }}
{{- end }}
{{- end }}
{{- $updateConfig := (.values.spec | default dict).updateConfig | default .defaultVals.spec.updateConfig }}
{{- if $updateConfig }}
{{- if and (hasKey $updateConfig "maxUnavailable") (hasKey $updateConfig "maxSurge") }}
  {{- fail (printf "Invalid value for updateConfig. Only one of maxUnavailable and maxSurge can be set") }}
{{- end }}
{{- end }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta2
kind: AWSManagedMachinePool
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
  amiType: {{ $amiType }}
  amiVersion: {{ (.values.spec | default dict).amiVersion | default .defaultVals.spec.amiVersion }}
  capacityType: {{ $capacityType }}
  diskSize: {{ (.values.spec | default dict).diskSize | default .defaultVals.spec.diskSize }}
  eksNodegroupName: {{ .name }}
  instanceType: {{ (.values.spec | default dict).instanceType | default .defaultVals.spec.instanceType }}
  {{- if or (.defaultVals.spec.roleName) ((.values.spec | default dict).roleName) }}
  roleName: {{ (.values.spec | default dict).roleName | default .defaultVals.spec.roleName }}
  {{- end }}
  {{- if $scaling }}
  scaling:
    {{- toYaml $scaling | nindent 4 }}
  {{- end }}
  {{- if .availabilityZones }}
  availabilityZones: {{- toYaml .availabilityZones | nindent 2 }}
  {{- end}}
  {{- if or (.defaultVals.spec.subnetIDs) ((.values.spec | default dict).subnetIDs) }}
  subnetIDs:
  {{- toYaml ((.values.spec | default dict).subnetIDs | default .defaultVals.spec.subnetIDs) | nindent 2 }}
  {{- end }}
  labels:
    {{- if (dig "spec" "labels" .values) -}}
    {{- toYaml (merge .values.spec.labels .defaultVals.spec.labels)| nindent 4 }}
    {{- else -}}
    {{- toYaml .defaultVals.spec.labels | nindent 4 }}
    {{- end }}
    {{- if eq (len .availabilityZones) 1 }}
    topology.ebs.csi.aws.com/zone: {{ index .availabilityZones 0 }}
    {{- end }}
  {{- if or (.defaultVals.spec.taints) ((.values.spec | default dict).taints) }}
  taints:
  {{- toYaml ((.values.spec | default dict).taints | default .defaultVals.spec.taints) | nindent 2 }}
  {{- end }}
  {{- if $updateConfig }}
  updateConfig:
    {{- toYaml $updateConfig | nindent 4 }}
  {{- end }}
  additionalTags:
    {{- if (dig "spec" "additionalTags" .values) }}
    {{- toYaml (merge .values.spec.additionalTags .defaultVals.spec.additionalTags) | nindent 4 }}
    {{- else -}}
    {{- toYaml .defaultVals.spec.additionalTags | nindent 4 }}
    {{- end }}
  {{- if or (.defaultVals.spec.roleAdditionalPolicies) ((.values.spec | default dict).roleAdditionalPolicies) }}
  roleAdditionalPolicies:
  {{- toYaml ((.values.spec | default dict).roleAdditionalPolicies | default .defaultVals.spec.roleAdditionalPolicies) | nindent 2 }}
  {{- end }}
---
{{- include "workers.machinePool" (dict "ctx" .ctx "name" .name "values" .values "defaultVals" .defaultVals) }}
{{- end }}
