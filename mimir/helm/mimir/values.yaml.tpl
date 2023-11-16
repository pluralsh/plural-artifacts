{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
{{ $traceShield := and .Configuration (index .Configuration "trace-shield") }}
{{ $grafanaAgent := and .Configuration (index .Configuration "grafana-agent") }}
{{ $tempo := and .Configuration .Configuration.tempo }}

{{- if or (eq .Provider "azure") (and $grafanaAgent $tempo) }}
{{ $grafanaAgentNamespace := namespace "grafana-agent" }}
global:
  {{- if and $grafanaAgent $tempo }}
  extraEnv:
  - name: JAEGER_AGENT_HOST
    value: grafana-agent-traces.{{ $grafanaAgentNamespace }}.svc
  - name: JAEGER_AGENT_PORT
    value: "6831"
  - name: JAEGER_SAMPLER_TYPE
    value: const
  - name: JAEGER_SAMPLER_PARAM
    value: "1"
  {{- end }}
  {{- if eq .Provider "azure" }}
  extraEnvFrom:
  - secretRef:
      name: mimir-azure-secret
  {{- end }}
{{- end }}


{{- if .Values.basicAuth }}
basicAuth:
  user: {{ .Values.basicAuth.user }}
  password: {{ .Values.basicAuth.password }}
{{- end }}

datasource:
{{- if $traceShield }}
  traceShield:
    enabled: true
    mimirPublicURL: {{ .Values.hostname }}
{{- else }}
  clusterTenantHeader:
    value: {{ .Cluster }}
    enabled: true
{{- end }}
{{- if .Configuration.tempo }}
  tempo:
    enabled: true
{{- end }}

mimir-distributed:
  {{- if eq .Provider "aws" }}
  serviceAccount:
    annotations:
      eks.amazonaws.com/role-arn: {{ importValue "Terraform" "iam_role_arn" }}
  {{- end }}
  {{- if $isGcp }}
  serviceAccount:
    annotations:
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "service_account_email" }}
  {{ end }}
  {{- if and .Values.basicAuth .Values.hostname (not $traceShield) }}
  gateway:
    enabledNonEnterprise: true
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
  {{- end }}
  metaMonitoring:
    serviceMonitor:
      clusterLabel: {{ .Cluster }}
  mimir:
    structuredConfig:
      alertmanager:
        external_url: https://{{ .Values.hostname }}/alertmanager
      common:
        storage:
          {{- if eq .Provider "aws" }}
          backend: s3
          s3:
            endpoint: s3.{{ .Region }}.amazonaws.com
            region: {{ .Region }}
          {{- else if $isGcp }}
          backend: gcs
          gcs:
          {{- else if eq .Provider "azure" }}
          backend: azure
          azure:
            account_name: ${AZURE_STORAGE_ACCOUNT}
            account_key: ${AZURE_STORAGE_KEY}
            endpoint_suffix: blob.core.windows.net
          {{- end }}
      blocks_storage:
        {{- if eq .Provider "aws" }}
        backend: s3
        s3:
          bucket_name: {{ .Values.mimirBlocksBucket }}
        {{- else if $isGcp }}
        backend: gcs
        gcs:
          bucket_name: {{ .Values.mimirBlocksBucket }}
        {{- else if eq .Provider "azure" }}
        backend: azure
        azure:
          container_name: {{ .Values.mimirBlocksBucket }}
        {{- end }}
      alertmanager_storage:
        {{- if and $traceShield .Values.hostname }}
        {{- end }}
        {{- if eq .Provider "aws" }}
        backend: s3
        s3:
          bucket_name: {{ .Values.mimirAlertBucket }}
        {{- else if $isGcp }}
        backend: gcs
        gcs:
          bucket_name: {{ .Values.mimirAlertBucket }}
        {{- else if eq .Provider "azure" }}
        backend: azure
        azure:
          container_name: {{ .Values.mimirAlertBucket }}
        {{- end }}
      ruler_storage:
        {{- if eq .Provider "aws" }}
        backend: s3
        s3:
          bucket_name: {{ .Values.mimirRulerBucket }}
        {{- else if $isGcp }}
        backend: gcs
        gcs:
          bucket_name: {{ .Values.mimirRulerBucket }}
        {{- else if eq .Provider "azure" }}
        backend: azure
        azure:
          container_name: {{ .Values.mimirRulerBucket }}
        {{- end }}
