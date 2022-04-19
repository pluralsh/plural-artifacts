{{ $monitoringNamespace := namespace "monitoring" }}
observabilityConfig:
  metrics.opencensus-address: plural-otel-collector.{{ $monitoringNamespace }}.svc.cluster.local:55678
tracingConfig:
  backend: zipkin
  zipkin-endpoint: "http://plural-otel-collector.{{ $monitoringNamespace }}.svc.cluster.local:9411/api/v2/spans"
  sample-rate: "1.0"
{{- if .Configuration.kubeflow }}
domainConfig:
  {{ .Configuration.kubeflow.hostname }}: ""
istioConfig:
  gateway.kubeflow.kubeflow-gateway: istio-ingressgateway.istio.svc.cluster.local
  local-gateway.knative.knative-local-gateway: "knative-local-gateway.istio.svc.cluster.local"
  enable-virtualservice-status: 'true'
kubeflow:
  enabled: true
{{- end }}
