auth_token = {{ .Context.ApiToken | quote }}
namespace = {{ .Namespace | quote }}
project_id = {{ .Project | quote }}
metro = {{ .Region | quote }}
cluster_name = {{ .Cluster | quote }}
worker_node_count_x86 = {{ .Values.worker_node_count_x86 }}
worker_node_plan_x86 = {{ .Values.worker_node_plan_x86 | quote }}
