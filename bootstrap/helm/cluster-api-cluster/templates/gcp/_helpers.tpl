{{/*
Function to template an GCPManagedMachinePool resource.
Params:
  ctx = . context
  name = the name of the GCPManagedMachinePool resource
  defaultVals = the default values for the GCPManagedMachinePool resource
  values = the values for this specific GCPManagedMachinePool resource
  availabilityZones = the availability zones for the GCPManagedMachinePool
*/}}
{{- define "workers.gcp.managedMachinePool" -}}
{{- $scaling := (.values.spec | default dict).scaling | default .defaultVals.spec.scaling }}
{{- if $scaling }}
{{- if not (and (hasKey $scaling "minCount") (hasKey $scaling "maxCount")) }}
  {{- fail (printf "Invalid value for scaling. Both minCount and maxCount must be set") }}
{{- end }}
{{- end }}
{{- $management := (.values.spec | default dict).management | default .defaultVals.spec.management }}
apiVersion: infrastructure.cluster.x-k8s.io/v1beta1
kind: GCPManagedMachinePool
metadata:
  name: {{ .name }}
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
spec:
  nodePoolName: {{ .name }}
  {{- if $scaling }}
  scaling:
    {{- toYaml $scaling | nindent 4 }}
  {{- end }}
  {{- if $management }}
  management:
    {{- toYaml $management | nindent 4 }}
  {{- end }}
  kubernetesLabels:
    {{- if (dig "spec" "kubernetesLabels" .values) }}
    {{- toYaml (merge .values.spec.kubernetesLabels .defaultVals.spec.kubernetesLabels) | nindent 4 }}
    {{- else }}
    {{- toYaml .defaultVals.spec.kubernetesLabels | nindent 4 }}
    {{- end }}
  {{- if or (.defaultVals.spec.kubernetesTaints) ((.values.spec | default dict).kubernetesTaints) }}
  kubernetesTaints:
  {{- toYaml ((.values.spec | default dict).kubernetesTaints | default .defaultVals.spec.kubernetesTaints) | nindent 4 }}
  {{- end }}
  additionalLabels:
    {{- if (dig "spec" "additionalLabels" .values) }}
    {{- toYaml (merge .values.spec.additionalLabels .defaultVals.spec.additionalLabels) | nindent 4 }}
    {{- else }}
    {{- toYaml .defaultVals.spec.additionalLabels | nindent 4 }}
    {{- end }}
  {{- if .values.spec.providerIDList }}
  providerIDList:
  {{- toYaml .values.spec.providerIDList | nindent 2 }}
  {{- end }}
  machineType: {{ (.values.spec | default dict).machineType | default .defaultVals.spec.machineType }}
  diskSizeGb: {{ (.values.spec | default dict).diskSizeGb | default .defaultVals.spec.diskSizeGb }}
  diskType: {{ (.values.spec | default dict).diskType | default .defaultVals.spec.diskType }}
  spot: {{ (.values.spec | default dict).spot | default .defaultVals.spec.spot }}
  preemptible: {{ (.values.spec | default dict).preemptible | default .defaultVals.spec.preemptible }}
  imageType: {{ (.values.spec | default dict).imageType | default .defaultVals.spec.imageType }}
---
{{- include "workers.machinePool" (dict "ctx" .ctx "name" .name "values" .values "defaultVals" .defaultVals) }}
{{- end }}
