{{ $hostname := .Values.hostname }}
{{ $notaryHostname := .Values.notaryHostname }}
{{- $redisNamespace := namespace "redis" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
{{ $postgresPass := dedupe . "harbor.postgres.password" (randAlphaNum 32) }}

postgres:
  password: {{ $postgresPass }}
harbor:
  jobservice:
    secret: {{ dedupe . "harbor.harbor.jobservice.secret" (randAlphaNum 32) }}
  registry:
    credentials:
      password: {{ dedupe . "harbor.harbor.registry.credentials.password" (randAlphaNum 32) }}
  core:
    xsrfKey: {{ dedupe . "harbor.harbor.core.xsrfKey" (randAlphaNum 32) }}
    secret: {{ dedupe . "harbor.harbor.core.secret" (randAlphaNum 32) }}
  harborAdminPassword:  {{ dedupe . "harbor.harbor.harborAdminPassword" (randAlphaNum 32) }}
  secretKey: {{ dedupe . "harbor.harbor.secretKey" (randAlphaNum 16) }}
  externalURL: https://{{ $hostname }}
  database:
    external:
      password: {{ $postgresPass }}
  expose:
    ingress:
      hosts:
        core: {{ $hostname }}
        notary: {{ $notaryHostname }}
  redis:
    external:
      addr: redis-master.{{ $redisNamespace }}:6379
      password: {{ $redisValues.redis.password }}