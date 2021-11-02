cluster_name = module.aws-bootstrap.cluster_name
vpc_name = {{ .Values.vpc_name | quote }}
namespace = {{ .Namespace | quote }}
cluster_private_subnets = module.aws-bootstrap.cluster_private_subnets
cluster_private_subnet_ids = module.aws-bootstrap.cluster_private_subnet_ids
