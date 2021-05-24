cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
filestore_bucket = {{ .Values.filestoreBucket | quote }}