namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
mimir_blocks_bucket = {{ .Values.mimirBlocksBucket | quote }}
mimir_alert_bucket = {{ .Values.mimirAlertBucket | quote }}
mimir_ruler_bucket = {{ .Values.mimirRulerBucket | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}