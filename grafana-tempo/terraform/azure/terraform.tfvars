cluster_name = {{ .Cluster | quote }}
namespace = {{ .Namespace | quote }}
resource_group = {{ .Project | quote }}
storage_account_name = {{ .Context.StorageAccount | quote }}
tempo_container = {{ .Values.tempoContainer | quote }}
