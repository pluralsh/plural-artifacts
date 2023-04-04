{{ $traceShield := (index .Configuration "trace-shield") }}
{{ $redisNamespace := namespace "redis" }}
{{ $redisValues := .Applications.HelmValues "redis" }}
{{ $monitoringNamespace := namespace "monitoring" }}
global:
  application:
    links:
    - description: loki api
      url: https://{{ .Values.hostname }}

redisPassword: {{ $redisValues.redis.password }}

{{- if and .Values.basicAuth (not $traceShield) }}
basicAuth:
  user: {{ .Values.basicAuth.user }}
  password: {{ .Values.basicAuth.password }}
{{- end }}

{{- if (index .Configuration "grafana-agent") }}
promtail:
  enabled: false
{{- end }}

datasource:
{{- if $traceShield }}
  traceShield:
    enabled: true
    lokiPublicURL: {{ .Values.hostname }}
{{- else }}
  clusterTenantHeader:
    value: {{ .Cluster }}
    enabled: true
{{- end }}
{{- if .Configuration.mimir }}
  mimir:
    enabled: true
{{- end }}
{{- if .Configuration.tempo }}
  tempo:
    enabled: true
{{- end }}

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
  {{- if and .Values.hostname .Values.basicAuth (not $traceShield) }}
  gateway:
    ingress:
      enabled: true
      annotations:
        nginx.ingress.kubernetes.io/auth-type: basic
        nginx.ingress.kubernetes.io/auth-secret: basic-auth
        nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required - foo'
      hosts:
      - host: {{ .Values.hostname | quote }}
        paths:
          - path: /
            pathType: Prefix
      tls:
      - hosts:
        - {{ .Values.hostname | quote }}
        secretName: loki-tls
  {{- else if and .Values.hostname (not $traceShield) }}
  gateway:
    ingress:
      enabled: true
      ingressClassName: internal-nginx
      hosts:
      - host: {{ .Values.hostname | quote }}
        paths:
          - path: /
            pathType: Prefix
      tls:
      - hosts:
        - {{ .Values.hostname | quote }}
        secretName: loki-tls
  {{- end }}
  loki:
    structuredConfig:
      {{- if $traceShield }}
      auth_enabled: true
      querier:
        multi_tenant_queries_enabled: true
      {{- else if .Values.multiTenant }}
      auth_enabled: {{ .Values.multiTenant }}
      querier:
        multi_tenant_queries_enabled: {{ .Values.multiTenant }}
      {{- end }}
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
