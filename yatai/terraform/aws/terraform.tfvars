namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
bucket = {{ .Values.bucket | quote }}
use_ecr = {{ .Values.use_ecr | quote }}
{{- if .Values.use_ecr }}
repository_type = {{ .Values.ecr_repository_type | quote }}
repository_name = {{ .Values.image_repository_name | quote }}
{{- end }}
