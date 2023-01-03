namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
minio_server = {{ .ObjectStore.Endpoint | quote }}
minio_ssl = {{ .ObjectStore.Ssl }}
minio_insecure = {{ .ObjectStore.Insecure }}
minio_access_key = {{ .ObjectStore.Username | quote }}
minio_secret_key = {{ .ObjectStore.Password | quote }}
{{- if .ObjectStore.Region }}
minio_region = {{ .ObjectStore.Region | quote }}
{{- end }}
