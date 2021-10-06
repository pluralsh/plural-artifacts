{{- if .Configuration.kubeflow }}
domainConfig:
  {{- .Configuration.kubeflow.hostname }}: ""
istioConfig:
  gateway.kubeflow.kubeflow-gateway: istio-ingressgateway.istio.svc.cluster.local
  local-gateway.knative.knative-local-gateway: "knative-local-gateway.istio.svc.cluster.local"
  enable-virtualservice-status: 'true'
{{- end }}
