project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
filestore_bucket = {{ .Values.filestoreBucket | quote }}
gcp_region = {{ .Region | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
