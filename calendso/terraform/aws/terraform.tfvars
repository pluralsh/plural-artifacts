cluster_name = {{ .Cluster | quote }}
namespace = module.kube.namespace.metadata.0.name