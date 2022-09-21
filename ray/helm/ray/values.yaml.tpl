{{ $redisValues := .Applications.HelmValues "redis" }}
global:
  application:
    links:
    - description: ray web ui
      url: {{ .Values.hostname }}

secrets:
  redis_host: redis-master.{{ namespace "redis" }}

ingress:
  svc: something
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: ray-tls
     hosts:
       - {{ .Values.hostname }}

ray-cluster:
  head:
    initArgs:
        redis-password: {{ $redisValues.redis.password }}
    envFrom:
        - secretRef:
            name: redis-secret

config:
  server:
    name: {{ .Values.hostname }}