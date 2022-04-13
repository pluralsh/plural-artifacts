namespace = {{ .Namespace | quote }}
workflow_bucket = {{ .Values.workflowBucket | quote }}

// minio configuration
minio_server = {{ .Configuration.minio.hostname | quote }}
minio_namespace = {{ namespace "minio" | quote }}