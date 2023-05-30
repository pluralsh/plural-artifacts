cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
project_id = {{ .Project | quote }}
backup_bucket = {{ .Values.backup_bucket | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
