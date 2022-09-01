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
    {{- if eq .Provider "kind" }}
    topologySpreadConstraints: {}
    autoscaling:
      enabled: false
   {{- end }}
    service:
      {{- if eq .Provider "kind" }}
      type: NodePort
      nodePorts:
        http: 30080
        https: 30443
      {{- end }}
      externalTrafficPolicy: Local
    {{- if eq .Provider "aws"}}
      annotations:
        service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
        service.beta.kubernetes.io/aws-load-balancer-type: external
        service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
        service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
        service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: '3600'
    config:
      compute-full-forwarded-for: 'true'
      use-forwarded-headers: 'true'
      use-proxy-protocol: 'true'
    {{- end }}
