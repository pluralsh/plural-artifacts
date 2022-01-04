cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
wal_bucket = {{ .Values.wal_bucket | quote }}
