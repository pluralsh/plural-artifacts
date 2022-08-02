namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
growthbook_bucket = {{ .Values.growthbookBucket | quote }}

// minio configuration
minio_server = {{ .Configuration.minio.hostname | quote }}
minio_namespace = {{ namespace "minio" | quote }}