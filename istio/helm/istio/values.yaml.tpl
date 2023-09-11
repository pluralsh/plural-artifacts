global:
  istioNamespace: {{ namespace "istio" }}

{{- if and .Configuration (index .Configuration "istio-cni") }}
istiod:
  istio_cni:
    enabled: true
{{- end }}
