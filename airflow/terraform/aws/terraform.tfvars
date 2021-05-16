cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
airflow_bucket = {{ .Values.airflowBucket | quote }}