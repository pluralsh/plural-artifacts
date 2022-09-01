{{ $redisValues := .Applications.HelmValues "redis" }}
global:
  application:
    links:
    - description: redash web ui
      url: {{ .Values.hostname }}

redash:
  redash:
    secretKey: {{ dedupe . "redash.redash.redash.secretKey" (randAlphaNum 32) }}
    cookieSecret: {{ dedupe . "redash.redash.redash.cookieSecret" (randAlphaNum 32) }}

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