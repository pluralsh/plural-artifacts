gcp_project_id = {{ .Project | quote }}
cluster_name = {{ .Cluster | quote }}
vpc_name_prefix = {{ .Values.vpc_name | quote }}
externaldns_sa_name = "{{ .Cluster }}-externaldns"
gcp_region = {{ .Region | quote }}
