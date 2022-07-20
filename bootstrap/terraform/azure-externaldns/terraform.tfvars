cluster_name = {{ .Cluster | quote }}
resource_group = {{ .Project | quote }}
dns_zone_name = {{ .Values.dns_zone | quote }}
