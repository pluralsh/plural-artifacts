namespace = {{ .Namespace | quote }}
dagster_bucket = {{ .Values.dagsterBucket | quote }}
cluster_name = {{ .Cluster | quote }}
project_id = {{ .Project | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}