namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
region = {{ .Region | quote }}
bucket = {{ .Values.bucket | quote }}
minio_namespace = {{ namespace "minio" | quote }}
minio_server = {{ .Configuration.minio.hostname | quote }}