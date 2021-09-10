{{ $minioNamespace := namespace "minio" }}
{{ $creds := secret $minioNamespace "minio-azure-secret" }}
namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
minio_server = minio.{{ $minioNamespace | quote }}
minio_access_key = {{ $creds.AZURE_STORAGE_ACCOUNT | quote }}
minio_secret_key = {{ $creds.AZURE_STORAGE_KEY | quote }}
