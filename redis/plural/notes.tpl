{{ if .Values.masterHostname }}
Your redis cluster has loadbalancing enabled.  You can access it at:

master: {{ .Values.masterHostname}}
{{ if .Values.replicaHostname }}
replica: {{ .Values.replicaHostname }}
{{ end }}
password: {{ .redis.password }}
{{ else }}
Your redis cluster is only available locally in your k8s cluster.

master: redis-master.redis
replica: redis-replicas.redis
password: {{ .redis.password }}
{{ end }}