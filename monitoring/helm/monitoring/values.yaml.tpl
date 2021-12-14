loki:
  enabled: false
  serviceMonitor:
    enabled: true
  serviceAccount:
    {{- if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-loki"
    {{- end }}
  config:
    schema_config:
      configs:
      - from: 2020-09-07
        store: boltdb-shipper
        {{- if eq .Provider "aws" }}
        object_store: s3
        {{- else }}
        object_store: filesystem
        {{- end }}
        schema: v11
        index:
          prefix: loki_index_
          period: 24h
    storage_config:
    {{- if eq .Provider "aws" }}
      boltdb_shipper:
        shared_store: s3
      aws:
        s3: s3://{{ .Region }}
        bucketnames: {{ .Values.loki_bucket }}
    {{- else }}
      boltdb_shipper:
        shared_store: filesystem
    {{- end }}

loki-distributed:
  enabled: true
  serviceMonitor:
    enabled: true
  ingester:
    persistence:
      enabled: true
  querier:
    persistence:
      enabled: false
  compactor:
    persistence:
      enabled: true
  ruler:
    persistence:
      enabled: false
  indexGateway:
    enabled: true
    persistence:
      enabled: true
  serviceAccount:
    {{- if eq .Provider "aws" }}
    annotations:
      eks.amazonaws.com/role-arn: "arn:aws:iam::{{ .Project }}:role/{{ .Cluster }}-loki"
    {{- end }}
  loki:
    config: |
      auth_enabled: false
      server:
        http_listen_port: 3100
      distributor:
        ring:
          kvstore:
            store: memberlist
      memberlist:
        join_members:
          - monitoring-loki-distributed-memberlist
      ingester:
        lifecycler:
          ring:
            kvstore:
              store: memberlist
            replication_factor: 1
        chunk_idle_period: 30m
        chunk_block_size: 262144
        chunk_encoding: snappy
        chunk_retain_period: 1m
        max_transfer_retries: 0
        wal:
          dir: /var/loki/wal
      limits_config:
        enforce_metric_name: false
        reject_old_samples: true
        reject_old_samples_max_age: 168h
        max_cache_freshness_per_query: 10m
      schema_config:
        configs:
          - from: 2020-09-07
            store: boltdb-shipper
            {{- if eq .Provider "aws" }}
            object_store: s3
            {{- else }}
            object_store: filesystem
            {{- end }}
            schema: v11
            index:
              prefix: loki_index_
              period: 24h
      storage_config:
        boltdb_shipper:
          {{- if eq .Provider "aws" }}
          shared_store: s3
          {{- else }}
          shared_store: filesystem
          {{- end }}
          active_index_directory: /var/loki/index
          cache_location: /var/loki/cache
          cache_ttl: 168h
          index_gateway_client:
            server_address: dns:///monitoring-loki-distributed-index-gateway:9095
        {{- if eq .Provider "aws" }}
        aws:
          s3: s3://{{ .Region }}
          bucketnames: {{ .Values.loki_bucket }}
        {{- else }}
        filesystem:
          directory: /var/loki/chunks
        {{- end }}
      chunk_store_config:
        max_look_back_period: 0s
      table_manager:
        retention_deletes_enabled: false
        retention_period: 0s
      query_range:
        align_queries_with_step: true
        max_retries: 5
        split_queries_by_interval: 15m
        cache_results: true
        results_cache:
          cache:
            enable_fifocache: true
            fifocache:
              max_size_items: 1024
              validity: 24h
      frontend_worker:
        frontend_address: monitoring-loki-distributed-query-frontend:9095
      frontend:
        log_queries_longer_than: 5s
        compress_responses: true
        tail_proxy_url: http://monitoring-loki-distributed-querier:3100
      compactor:
        shared_store: filesystem
      ruler:
        storage:
          type: local
          local:
            directory: /etc/loki/rules
        ring:
          kvstore:
            store: memberlist
        rule_path: /tmp/loki/scratch
        alertmanager_url: https://alertmanager.xx
        external_url: https://alertmanager.xx

{{ $grafanaNamespace := namespace "grafana" }}
kube-prometheus-stack:
  grafana:
    namespaceOverride: {{ $grafanaNamespace }}
  prometheus:
    prometheusSpec:
      externalLabels:
        cluster: {{ .Cluster }}

{{- if .Configuration }}
{{- if index .Configuration "grafana-tempo" }}
{{ $tempoNamespace := namespace "grafana-tempo" }}
opentelemetry-operator:
  collector:
    enabled: true
    tempoNamespace: {{ $tempoNamespace }}
{{- end }}
{{- end }}
