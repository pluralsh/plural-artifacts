namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
bucket = {{ .Values.bucket | quote }}
use_ecr = {{ .Values.use_ecr | quote }}
repository_type = {{ .Values.ecr_repository_type | quote }}
repository_name = {{ .Values.ecr_repository_name | quote }}
