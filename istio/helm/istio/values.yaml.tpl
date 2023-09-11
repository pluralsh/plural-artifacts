global:
  istioNamespace: {{ namespace "istio" }}

{{- if and .Configuration .Configuration.istio-cni }}
istiod:
  istio_cni:
    enabled: true
{{- end }}
