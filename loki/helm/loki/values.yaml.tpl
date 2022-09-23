{{ $redisNamespace := namespace "redis" }}
{{ $redisValues := .Applications.HelmValues "redis" }}
{{ $monitoringNamespace := namespace "monitoring" }}
redisPassword: {{ $redisValues.redis.password }}
loki-distributed:
  {{- if eq .Provider "google" }}
  serviceAccount:
    create: false
  {{- end }}
  {{- if eq .Provider "aws" }}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-loki"
  {{- end }}
  loki:
    structuredConfig:
      common:
        storage:
          {{- if eq .Provider "aws" }}
          s3:
            s3: s3://{{ .Region }}
            bucketnames: {{ .Values.lokiBucket }}
            region: {{ .Region }}
          {{- else if eq .Provider "google" }}
          gcs:
            bucket_name: {{ .Values.lokiBucket }}
          {{- else if eq .Provider "azure" }}
          azure:
            environment: AzureGlobal
            container_name: {{ .Values.lokiContainer }}
            account_name: ${AZURE_STORAGE_ACCOUNT}
            account_key: ${AZURE_STORAGE_KEY}
          {{- end }}
      chunk_store_config:
        chunk_cache_config:
          redis:
            endpoint: redis-master.{{ $redisNamespace }}:6379
        write_dedupe_cache_config:
          redis:
            endpoint: redis-master.{{ $redisNamespace }}:6379
      query_range:
        results_cache:
          cache:
            redis:
              endpoint: redis-master.{{ $redisNamespace }}:6379
      ruler:
        alertmanager_url: http://monitoring-alertmanager.{{ $monitoringNamespace }}:9093
        external_url: ""
        storage:
          {{- if eq .Provider "aws" }}
          type: s3
          {{- else if eq .Provider "google" }}
          type: gcs
          {{- else if eq .Provider "azure" }}
          type: azure
          {{- end }}
      storage_config:
        index_queries_cache_config:
          redis:
            endpoint: redis-master.{{ $redisNamespace }}:6379
        {{- if eq .Provider "aws" }}
        aws:
          s3: s3://{{ .Region }}
          bucketnames: {{ .Values.lokiBucket }}
          region: {{ .Region }}
        boltdb_shipper:
          shared_store: s3
        {{- else if eq .Provider "google" }}
        gcs:
          bucket_name: {{ .Values.lokiBucket }}
        boltdb_shipper:
          shared_store: gcs
        {{- else if eq .Provider "azure" }}
        azure:
          environment: AzureGlobal
          container_name: {{ .Values.lokiContainer }}
          account_name: ${AZURE_STORAGE_ACCOUNT}
          account_key: ${AZURE_STORAGE_KEY}
        {{- end }}
      {{- if eq .Provider "aws" }}
      compactor:
        shared_store: s3
      schema_config:
        configs:
          - from: 2020-09-07
            store: boltdb-shipper
            object_store: aws
            schema: v11
            index:
              prefix: loki_index_
              period: 24h
      {{- else if eq .Provider "google" }}
      compactor:
        shared_store: gcs
      schema_config:
        configs:
          - from: 2020-09-07
            store: boltdb-shipper
            object_store: gcs
            schema: v11
            index:
              prefix: loki_index_
              period: 24h
      {{- else if eq .Provider "azure" }}
      compactor:
        shared_store: azure
      schema_config:
        configs:
          - from: 2020-09-07
            store: boltdb-shipper
            object_store: azure
            schema: v11
            index:
              prefix: loki_index_
              period: 24h
      {{- end }}
  {{- if eq .Provider "azure" }}
  ingester:
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  distributor:
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  querier:
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  queryFrontend:
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  tableManager:
    enabled: false
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  compactor:
    enabled: true
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  ruler:
    enabled: true
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  indexGateway:
    enabled: true
    extraArgs:
    - -config.expand-env=true
    extraEnvFrom:
    - secretRef:
        name: redis-password
    - secretRef:
        name: loki-azure-secret
  {{- end }}
