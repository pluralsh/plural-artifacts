password: {{ dedupe . "redis.password" (randAlphaNum 26) }}

{{ if .Values.masterHostname }}
redis:
  master:
    service:
      type: LoadBalancer
      annotations:
      {{ if eq .Provider "aws" }}
        service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
        service.beta.kubernetes.io/aws-load-balancer-type: external
        service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
        service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: '3600'
      {{ end }}
        external-dns.alpha.kubernetes.io/hostname: {{ .Values.masterHostname }}
  {{ if .Values.replicaHostname }}
  replica:
    service:
      type: LoadBalancer
      annotations:
      {{ if eq .Provider "aws" }}
        service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
        service.beta.kubernetes.io/aws-load-balancer-type: external
        service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
        service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: '3600'
      {{ end }}
        external-dns.alpha.kubernetes.io/hostname: {{ .Values.replicaHostname }}
  {{ end }}
{{ end }}