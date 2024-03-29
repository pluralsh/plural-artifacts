global:
  application:
    links:
    - description: neo4j web ui
      url: {{ .Values.hostname }}

neo4j:
  services:
    neo4j:
      hostname: {{ .Values.hostname }}
      annotations:
        external-dns.alpha.kubernetes.io/hostname: {{ .Values.hostname }}
      {{ if eq .Provider "aws" }}
        service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
        service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
        service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
        service.beta.kubernetes.io/aws-load-balancer-type: external
        service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
        service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
        service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: '3600'
      {{ end }}
