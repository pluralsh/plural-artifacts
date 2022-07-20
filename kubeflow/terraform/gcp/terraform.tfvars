project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
pipelines_bucket = {{ .Values.pipelines_bucket | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
