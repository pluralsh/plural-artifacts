namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
minio_server = {{ .ObjectStore.endpoint | quote }}
minio_ssl = {{ .ObjectStore.ssl }}
minio_insecure = {{ .ObjectStore.insecure }}
minio_access_key = {{ .ObjectStore.username | quote }}
minio_secret_key = {{ .ObjectStore.password | quote }}
