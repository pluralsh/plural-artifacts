project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
tempo_bucket = {{ .Values.tempoBucket | quote }}
gcp_region = {{ .Region | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
