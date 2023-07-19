project_id = {{ .Project | quote }}
namespace = {{ .Namespace | quote }}
mlflow_bucket = {{ .Values.mlflow_bucket | quote }}
gcp_region = {{ .Region | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
