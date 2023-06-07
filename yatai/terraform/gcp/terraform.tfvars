project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
bucket = {{ .Values.bucket | quote }}
region = {{ .Region | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}