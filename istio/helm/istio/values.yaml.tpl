{{ $grafanaAgent := and .Configuration (index .Configuration "grafana-agent") }}
{{ $tempo := and .Configuration .Configuration.tempo }}

global:
  istioNamespace: {{ namespace "istio" }}
  {{/* {{- if and $grafanaAgent $tempo }}
  tracer:
        zipkin:
          address:
  {{- end }} */}}

{{- if or (and $grafanaAgent $tempo) (chartInstalled "istio-cni" "istio-cni") }}
istiod:
  {{- if and $grafanaAgent $tempo }}
  {{ $grafanaAgentNamespace := namespace "grafana-agent" }}
  meshConfig:
    enableTracing: true
    defaultConfig:
      tracing:
        zipkin:
          address: grafana-agent-traces.{{ $grafanaAgentNamespace }}.svc:9411
  {{- end }}
  {{- if chartInstalled "istio-cni" "istio-cni" }}
  istio_cni:
    enabled: true
  {{- end }}
{{- end }}
