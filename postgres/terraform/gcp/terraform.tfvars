cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
project_id = {{ .Project | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
