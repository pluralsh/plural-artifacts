namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
project_id = {{ .Project | quote }}
bucket = {{ .Values.bucket | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
