cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
project_id = {{ .Project | quote }}
backup_bucket = {{ .Configuration.mysql.backup_bucket | quote }}
