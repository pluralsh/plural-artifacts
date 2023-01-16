{{- $bootstrapOutputs := .Applications.TerraformValues "bootstrap" }}


{{- if $bootstrapOutputs }}
config:
  allowedIPs:
  {{- if eq .Provider "aws" }}
  - {{ $bootstrapOutputs.vpc_cidr | quote }}
  - {{ $bootstrapOutputs.cluster_service_ipv4_cidr | quote }}
  {{- if .Values.routePublicIPs }}
  - "0.0.0.0/0"
  {{- end }}
  {{- end }}
{{- end }}

{{- if eq .Provider "aws" }}
service:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
    service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
    service.beta.kubernetes.io/aws-load-balancer-type: external
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-protocol: HTTP
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-port: "9586"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: "/metrics"
{{- end }}
