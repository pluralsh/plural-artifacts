{{ $traceShield := and .Configuration (index .Configuration "trace-shield") }}
{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}

{{- if eq .Provider "aws" }}
provider: aws
{{- else if $isGcp }}
provider: google
{{- else if eq .Provider "azure" }}
provider: azure
tempoStorageIdentityId: {{ importValue "Terraform" "tempo_msi_id" }}
tempoStorageIdentityClientId: {{ importValue "Terraform" "tempo_msi_client_id" }}
{{- end }}

datasource:
{{- if $traceShield }}
  traceShield:
    enabled: true
    tempoPublicURL: {{ .Values.hostname }}
{{- else }}
  clusterTenantHeader:
    value: {{ .Cluster }}
    enabled: true
{{- end }}
{{- if .Configuration.loki }}
  loki:
    enabled: true
{{- end }}
{{- if .Configuration.mimir }}
  mimir:
    enabled: true
{{- end }}

tempo-distributed:
  {{- if or (eq .Provider "aws") $isGcp }}
  serviceAccount:
    annotations:
      {{- if eq .Provider "aws" }}
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
      {{- else if $isGcp }}
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "iam_service_account" }}
      {{- end }}
  {{- end }}
  {{- if and (eq .Provider "azure") (index .Configuration "grafana-agent") }}
  ingester:
    {{- if (index .Configuration "grafana-agent") }}
    extraEnv:
    - name: JAEGER_AGENT_HOST
      value: grafana-agent-traces.grafana-agent.svc
    - name: JAEGER_AGENT_PORT
      value: "6831"
    - name: JAEGER_SAMPLER_TYPE
      value: const
    - name: JAEGER_SAMPLER_PARAM
      value: "0.1"
    {{- end }}
    {{- if eq .Provider "azure" }}
    podLabels:
      aadpodidbinding: tempo
    {{- end }}
  distributor:
    {{- if (index .Configuration "grafana-agent") }}
    extraEnv:
    - name: JAEGER_AGENT_HOST
      value: grafana-agent-traces.grafana-agent.svc
    - name: JAEGER_AGENT_PORT
      value: "6831"
    - name: JAEGER_SAMPLER_TYPE
      value: const
    - name: JAEGER_SAMPLER_PARAM
      value: "0.1"
    {{- end }}
    {{- if eq .Provider "azure" }}
    podLabels:
      aadpodidbinding: tempo
    {{- end }}
  compactor:
    {{- if (index .Configuration "grafana-agent") }}
    extraEnv:
    - name: JAEGER_AGENT_HOST
      value: grafana-agent-traces.grafana-agent.svc
    - name: JAEGER_AGENT_PORT
      value: "6831"
    - name: JAEGER_SAMPLER_TYPE
      value: const
    - name: JAEGER_SAMPLER_PARAM
      value: "0.1"
    {{- end }}
    {{- if eq .Provider "azure" }}
    podLabels:
      aadpodidbinding: tempo
    {{- end }}
  querier:
    {{- if (index .Configuration "grafana-agent") }}
    extraEnv:
    - name: JAEGER_AGENT_HOST
      value: grafana-agent-traces.grafana-agent.svc
    - name: JAEGER_AGENT_PORT
      value: "6831"
    - name: JAEGER_SAMPLER_TYPE
      value: const
    - name: JAEGER_SAMPLER_PARAM
      value: "0.1"
    {{- end }}
    {{- if eq .Provider "azure" }}
    podLabels:
      aadpodidbinding: tempo
    {{- end }}
  queryFrontend:
    {{- if (index .Configuration "grafana-agent") }}
    extraEnv:
    - name: JAEGER_AGENT_HOST
      value: grafana-agent-traces.grafana-agent.svc
    - name: JAEGER_AGENT_PORT
      value: "6831"
    - name: JAEGER_SAMPLER_TYPE
      value: const
    - name: JAEGER_SAMPLER_PARAM
      value: "0.1"
    {{- end }}
    {{- if eq .Provider "azure" }}
    podLabels:
      aadpodidbinding: tempo
    {{- end }}
  {{- if .Configuration.mimir }}
  metricsGenerator:
    enabled: true
    {{- if (index .Configuration "grafana-agent") }}
    extraEnv:
    - name: JAEGER_AGENT_HOST
      value: grafana-agent-traces.grafana-agent.svc
    - name: JAEGER_AGENT_PORT
      value: "6831"
    - name: JAEGER_SAMPLER_TYPE
      value: const
    - name: JAEGER_SAMPLER_PARAM
      value: "0.1"
    {{- end }}
    {{- if eq .Provider "azure" }}
    podLabels:
      aadpodidbinding: tempo
    {{- end }}
    config:
      storage:
        remote_write:
        - url: http://mimir-nginx.mimir/api/v1/push
          headers:
            X-Scope-OrgID: {{ .Cluster }}
  {{- end }}
  {{- end }}
  storage:
    trace:
      {{- if eq .Provider "aws" }}
      backend: s3
      s3:
        bucket: {{ .Values.tempoBucket }}
        endpoint: s3.amazonaws.com
        region: {{ .Region }}
      {{- else if $isGcp }}
      backend: gcs
      gcs:
        bucket_name: {{ .Values.tempoBucket }}
      {{- else if eq .Provider "azure" }}
      backend: azure
      azure:
        container_name: {{ .Values.tempoContainer }}
        storage_account_name: {{ .Context.StorageAccount }}
        user_assigned_id: {{ importValue "Terraform" "tempo_msi_client_id" }}
      {{- end }}
