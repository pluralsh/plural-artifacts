{{ $redisNamespace := namespace "redis" }}
{{ $creds := secret $redisNamespace "redis-password" }}
tempo-distributed:
  serviceAccount:
    {{- if eq .Provider "google" }}
    create: false
    {{- end }}
    {{- if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-tempo"
    {{- end }}
  {{- if eq .Provider "azure" }}
  ingester:
    podLabels:
      aadpodidbinding: tempo
  distributor:
    podLabels:
      aadpodidbinding: tempo
  compactor:
    podLabels:
      aadpodidbinding: tempo
  querier:
    podLabels:
      aadpodidbinding: tempo
  queryFrontend:
    podLabels:
      aadpodidbinding: tempo
  gateway:
    podLabels:
      aadpodidbinding: tempo
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
      {{- else if eq .Provider "aws" }}
      backend: gcs
      gcs:
        bucket_name: {{ .Values.tempoBucket }}
      {{- else if eq .Provider "azure" }}
      backend: azure
      azure:
        container-name: {{ .Values.tempoContainer }}
        storage-account-name: {{ .Context.StorageAccount }}
      {{- end }}
