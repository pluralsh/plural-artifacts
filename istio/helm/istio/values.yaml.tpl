global:
  istioNamespace: {{ namespace "istio" }}

{{- if chartInstalled "istio-cni" "istio-cni" }}
istiod:
  istio_cni:
    enabled: true
{{- end }}
