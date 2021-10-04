{{ $redisNamespace := namespace "redis" }}
{{ $creds := secret $redisNamespace "redis-password" }}
tempo-distributed:
  serviceAccount:
    {{- if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-tempo"
    {{- end }}
  storage:
    trace:
      cache: redis
      redis:
        endpoint: redis-master.{{ $redisNamespace }}:6379
        db: 5
        password: {{ $creds.password }}
      {{- if eq .Provider "aws" }}
      backend: s3
      s3:
        bucket: {{ .Values.tempoBucket }}
        endpoint: s3.amazonaws.com
        region: {{ .Region }}
      {{- end }}
