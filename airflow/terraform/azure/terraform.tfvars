cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
resource_group = {{ .Project | quote }}
airflow_bucket = {{ .Values.airflowBucket | quote }}

// minio configuration
minio_server = {{ .Configuration.minio.hostname | quote }}
minio_namespace = {{ namespace "minio" | quote }}