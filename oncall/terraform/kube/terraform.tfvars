namespace = {{ .Namespace | quote }}
cluster_name = {{ .Cluster | quote }}
rabbitmq_namespace = {{ namespace "rabbitmq" | quote }}
