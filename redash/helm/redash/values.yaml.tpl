{{ $redisValues := .Applications.HelmValues "redis" }}
global:
  application:
    links:
    - description: redash web ui
      url: {{ .Values.hostname }}


secrets:
  redis_host: redis-master.{{ namespace "redis" }}
  redis_password: {{ $redisValues.redis.password }}

ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: redash-tls
     hosts:
       - {{ .Values.hostname }}