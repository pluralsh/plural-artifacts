namespace = {{ .Namespace | quote }}
project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
gcp_location = {{ .Region | quote }}
chatwoot_bucket = {{ .Values.chatwootBucket | quote }}
