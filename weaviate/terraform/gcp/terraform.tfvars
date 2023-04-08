namespace = {{ .Namespace | quote }}
weaviate_bucket = {{ .Values.weaviateBucket | quote }}
cluster_name = {{ .Cluster | quote }}
project_id = {{ .Project | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
