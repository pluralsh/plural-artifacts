namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
resource_group = {{ .Project | quote }}
storage_account_name = {{ .Context.StorageAccount | quote }}
