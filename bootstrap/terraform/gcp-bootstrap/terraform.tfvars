gcp_project_id = {{ .Project | quote }}
dns_zone_name = {{ .Values.dns_zone_name | quote }}
cluster_name = {{ .Cluster | quote }}
vpc_network_name = {{ .Values.vpc_name | quote }}
externaldns_sa_name = "{{ .Cluster }}-externaldns"