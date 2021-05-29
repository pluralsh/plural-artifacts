vpc_name = {{ .Values.vpc_name | quote }}
dns_domain = {{ .Values.dns_domain | quote }}
cluster_name = {{ .Cluster | quote }}

map_roles = [
  {
    rolearn = "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-console"
    username = "console"
    groups = ["system:masters"]
  }
]