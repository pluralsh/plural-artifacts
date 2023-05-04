{{- $redisNamespace := namespace "redis" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
harbor:
  redis:
    external:
      addr: redis-master.{{ $redisNamespace }}:6379
      password: {{ $redisValues.redis.password }}