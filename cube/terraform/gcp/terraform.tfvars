namespace = {{ .Namespace | quote }}
cube_bucket = {{ .Values.cubeBucket | quote }}
cluster_name = {{ .Cluster | quote }}
project_id = {{ .Project | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
