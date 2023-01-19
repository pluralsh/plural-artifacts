namespace = {{ .Namespace | quote }}
dagster_bucket = {{ .Values.dagsterBucket | quote }}

// minio configuration
minio_server = {{ .Configuration.minio.hostname | quote }}
minio_namespace = {{ namespace "minio" | quote }}