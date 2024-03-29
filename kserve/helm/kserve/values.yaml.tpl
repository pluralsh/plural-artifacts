{{ $istioNamespace := namespace "istio" }}
{{ $knativeNamespace := namespace "knative" }}
{{ $kubeflowNamespace := namespace "kubeflow" }}
kserve:
  kserve:
    controller:
      gateway:
        {{- if .Configuration.kubeflow }}
        domain: {{ .Configuration.kubeflow.hostname }}
        {{- end }}
        localGateway:
          gateway: {{ $knativeNamespace }}/knative-local-gateway
          gatewayService: knative-local-gateway.{{ $istioNamespace }}.svc.cluster.local
        {{- if .Configuration.kubeflow }}
        ingressGateway:
          gateway: {{ $kubeflowNamespace }}/kubeflow-gateway
          gatewayService: istio-ingressgateway.{{ $istioNamespace }}.svc.cluster.local
        {{- else }}
        ingressGateway:
          gateway: {{ $knativeNamespace }}/knative-ingress-gateway
          gatewayService: istio-ingressgateway.{{ $istioNamespace }}.svc.cluster.local
        {{- end }}
