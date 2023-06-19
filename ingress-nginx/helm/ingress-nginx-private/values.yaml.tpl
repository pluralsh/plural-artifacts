ingress-nginx:
  {{- if .Configuration.gitlab }}
  tcp:
    {{- if eq .Provider "aws" }}
    22: gitlab/gitlab-gitlab-shell:22:PROXY
    {{- else }}
    22: gitlab/gitlab-gitlab-shell:22
    {{- end }}
  {{- end }}
  controller:
    electionID: internal-ingress-controller-leader
    service:
      externalTrafficPolicy: Local
    {{- if eq .Provider "aws"}}
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
        service.beta.kubernetes.io/aws-load-balancer-type: external
        service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
        service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
        service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: '3600'
    {{- end }}
    {{- if or (eq .Provider "aws") (and (.Configuration.tempo) (index .Configuration "grafana-agent")) }}
    config:
      {{- if and (.Configuration.tempo) (index .Configuration "grafana-agent") }}
      enable-opentelemetry: "true"
      opentelemetry-config: "/etc/nginx/opentelemetry.toml"
      opentelemetry-operation-name: "HTTP $request_method $service_name $uri"
      opentelemetry-trust-incoming-span: "true"
      otlp-collector-host: "grafana-agent-traces.grafana-agent.svc"
      otlp-collector-port: "4317"
      otel-max-queuesize: "2048"
      otel-schedule-delay-millis: "5000"
      otel-max-export-batch-size: "512"
      otel-service-name: "internal-nginx" # Opentelemetry resource name
      otel-sampler: "AlwaysOn" # Also: AlwaysOff, TraceIdRatioBased
      otel-sampler-ratio: "1.0"
      otel-sampler-parent-based: "false"
      {{- end }}
      {{- if eq .Provider "aws"}}
      compute-full-forwarded-for: 'true'
      use-forwarded-headers: 'true'
      use-proxy-protocol: 'true'
      {{- end }}
    {{- end }}
