{{- $redisNamespace := namespace "redis" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
renovate:
  cronjob:
    # Every 15 minutes
    schedule: '*/15 * * * *'
  secrets:
    RENOVATE_TOKEN: {{ .Values.renovate_token }}
    GITHUB_COM_TOKEN: {{ .Values.github_pat }}
    RENOVATE_REDIS_URL: "redis://:{{ $redisValues.redis.password }}@redis-master.{{ $redisNamespace }}:6379"
    RENOVATE_GIT_AUTHOR: {{ .Values.git_author }}
  renovate:
    config: |
      {
        "platform": "{{ .Values.renovate_platform }}",
        "autodiscover": "true",
        "autodiscoverFilter": "{{ .Values.autodiscover_filter }}",
        "dryRun": "{{ .Values.dry_run }}",
        "printConfig": true
      }
