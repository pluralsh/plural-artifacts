namespace = {{ .Namespace | quote }}
directus_bucket = {{ .Values.directusBucket | quote }}
cluster_name = {{ .Cluster | quote }}
project_id = {{ .Project | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
