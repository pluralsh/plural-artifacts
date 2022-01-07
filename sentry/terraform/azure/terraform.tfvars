namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
filestore_bucket = {{ .Values.filestoreBucket | quote }}
minio_server = {{ .Configuration.minio.hostname | quote }}
minio_namespace = {{ namespace "minio" | quote }}