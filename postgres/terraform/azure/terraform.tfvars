namespace = {{ .Namespace | quote }}
minio_namespace = {{ namespace "minio" }}
cluster_name = {{ .Cluster | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
minio_server = {{ .Configuration.minio.hostname | quote }}
