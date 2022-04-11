namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
project_id = {{ .Project | quote }}
loki_bucket = {{ .Values.lokiBucket | quote }}
bucket_location = {{ .Context.BucketLocation }}
