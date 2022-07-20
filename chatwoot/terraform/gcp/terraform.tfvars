namespace = {{ .Namespace | quote }}
project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
gcp_region = {{ .Region | quote }}
chatwoot_bucket = {{ .Values.chatwootBucket | quote }}
bucket_location = {{ .Context.BucketLocation | quote }}
