{{ $minioNamespace := namespace "minio" }}
{{ $minioHostname := .Configuration.minio.hostname }}
{{ $creds := secret $minioNamespace "minio-root-secret" }}
namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
nextcloud_bucket = {{ .Values.nextcloud_bucket | quote }}
minio_server = {{ $minioHostname | quote }}
minio_access_key = {{ $creds.rootUser | quote }}
minio_secret_key = {{ $creds.rootPassword | quote }}
