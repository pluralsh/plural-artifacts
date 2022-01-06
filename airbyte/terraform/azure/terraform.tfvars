namespace = {{ .Namespace | quote }}
airbyte_bucket = {{ .Values.airbyteBucket | quote }}
minio_namespace = {{ namespace "minio" | quote }}
minio_server = {{ .Configuration.minio.hostname | quote }}