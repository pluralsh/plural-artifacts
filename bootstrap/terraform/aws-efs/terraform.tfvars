cluster_name = module.aws-bootstrap.cluster_name
vpc_name = {{ .Values.vpc_name | quote }}
namespace = {{ .Namespace | quote }}
