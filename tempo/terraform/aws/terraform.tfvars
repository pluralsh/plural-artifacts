cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
tempo_bucket = {{ .Values.tempoBucket | quote }}
