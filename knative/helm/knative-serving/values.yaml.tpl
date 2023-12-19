
{{- if .Configuration.kubeflow }}
knative-serving:
  configDomain:
    data:
      {{ .Configuration.kubeflow.hostname }}: ""
  net-istio:
    configIstio:
      data:
        gateway.kubeflow.kubeflow-gateway: kubeflow-gateway.kubeflow.svc.cluster.local
        local-gateway.knative.knative-local-gateway: "knative-local-gateway.kubeflow.svc.cluster.local"
        enable-virtualservice-status: 'true'
    istio:
      namespace: kubeflow
      ingressGateway:
        create: false
      localGateway:
        selector:
          istio: kubeflow-gateway
kubeflow:
  enabled: true
{{- end }}
