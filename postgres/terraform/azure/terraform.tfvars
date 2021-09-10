{{ $minioNamespace := namespace "minio" }}
{{ $creds := secret $minioNamespace "minio-root-secret" }}
namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
minio_server = "minio.minio:9000"
minio_access_key = {{ $creds.rootUser | quote }}
minio_secret_key = {{ $creds.rootPassword | quote }}
