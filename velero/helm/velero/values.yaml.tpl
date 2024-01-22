{{- if eq .Provider "aws" }}
podAnnotations:
  iam.amazonaws.com/role: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-velero"

initContainers:
 - name: velero-plugin-for-aws
   image: velero/velero-plugin-for-aws:v1.8.0
   imagePullPolicy: IfNotPresent
   volumeMounts:
     - mountPath: /target
       name: plugins
{{- end }}

configuration:
  backupStorageLocation:
    provider: {{ .Provider }}
    bucket: {{ .Values.velero_bucket | quote }}
    config:
      region: {{ .Region }}
  volumeSnapshotLocation:
    provider: {{ .Provider }}
    config:
      region: {{ .Region }}