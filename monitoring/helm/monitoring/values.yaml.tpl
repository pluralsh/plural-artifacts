global:
  rbac:
    pspEnabled: false

loki-distributed:
  loki:
    structuredConfig:
      storage_config:
        aws:
          s3: s3://{{ .Region }}
          bucketnames: {{ .Values.lokiBucket }}

kube-prometheus-stack:
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
