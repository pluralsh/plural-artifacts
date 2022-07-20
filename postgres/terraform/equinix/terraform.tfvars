namespace = {{ .Namespace | quote }}
minio_namespace = {{ namespace "minio" | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
minio_server = {{ .Configuration.minio.hostname | quote }}
