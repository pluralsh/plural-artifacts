namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
resource_group = {{ .Project | quote }}
storage_account_name = {{ .Context.StorageAccount | quote }}
mimir_blocks_bucket = {{ .Values.mimirBlocksBucket | quote }}
mimir_alert_bucket = {{ .Values.mimirAlertBucket | quote }}
mimir_ruler_bucket = {{ .Values.mimirRulerBucket | quote }}
