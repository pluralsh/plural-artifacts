project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
airbyte_bucket = {{ .Values.airbyteBucket | quote }}
gcp_region = {{ .Region | quote }}
bucket_location = {{ default "US" .Context.BucketLocation | quote }}
