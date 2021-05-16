project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
airflow_bucket = {{ .Values.airflowBucket | quote }}
gcp_location = {{ .Region | quote }}