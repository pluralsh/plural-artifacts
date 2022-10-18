{{- $redisNamespace := namespace "redis" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
{{- $rabbitmqNamespace := namespace "rabbitmq" }}
oncall:
  externalRabbitmq:
    host: rabbitmq.{{ $rabbitmqNamespace }}
    user: {{ importValue "Terraform" "rabbitmq_username" }}
    password: {{ importValue "Terraform" "rabbitmq_password" }}
  externalRedis:
    host: redis-master.{{ $redisNamespace }}
    password: {{ $redisValues.redis.password }}
