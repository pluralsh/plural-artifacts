project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
airflow_bucket = {{ .Values.airbyteBucket | quote }}
gcp_location = {{ .Region | quote }}