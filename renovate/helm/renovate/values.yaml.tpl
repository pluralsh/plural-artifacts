{{- $redisNamespace := namespace "redis" }}
{{- $redisValues := .Applications.HelmValues "redis" }}
renovate:
  ssh_config:
    id_rsa: {{ .Values.private_key }}
    id_rsa_pub: {{ .Values.public_key }}
  secrets:
    GITHUB_COM_TOKEN: {{ .Values.github_pat }}
    RENOVATE_REDIS_URL: "redis://:{{ $redisValues.redis.password }}@redis-master.{{ $redisNamespace }}:6379"
  renovate:
    config: |
      {
        "platform": "{{ .Values.renovate_platform }}",
        "autodiscover": "true",
        "autodiscoverFilter": "{{ .Values.autodiscover_filter }}",
        "dryRun": "{{ .Values.dry_run }}",
        "printConfig": true
      }
