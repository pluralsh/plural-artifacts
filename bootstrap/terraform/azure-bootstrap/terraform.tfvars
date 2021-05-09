resource_group = {{ .Project | quote }}
name = {{ .Cluster | quote }}
dns_zone_name = {{ .Values.dns_domain | quote }}
namespace = {{ .Namespace | quote }}