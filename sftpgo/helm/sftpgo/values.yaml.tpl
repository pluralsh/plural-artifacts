{{ $isGcp := or (eq .Provider "google") (eq .Provider "gcp") }}
{{ $sftpgoPgPwd := dedupe . "sftpgo.postgres.password" (randAlphaNum 20) }}

postgres:
  password: {{ $sftpgoPgPwd }}

global:
  application:
    links:
    - description: sftpgo web ui
      url: {{ .Values.hostname }}

sftpgo:
  ui:
    ingress:
      hosts:
      - host: {{ .Values.hostname }}
        paths:
          - path: '/'
            pathType: ImplementationSpecific
      tls:
      - secretName: sftpgo-tls
        hosts:
          - {{ .Values.hostname }}
  {{ if .Values.loadBalancerHostname }}
  service:
    type: LoadBalancer
    annotations:
      external-dns.alpha.kubernetes.io/hostname: {{ .Values.loadBalancerHostname }}
    {{ if eq .Provider "aws" }}
      service.beta.kubernetes.io/aws-load-balancer-scheme: internet-facing
      service.beta.kubernetes.io/aws-load-balancer-backend-protocol: tcp
      service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled: 'true'
      service.beta.kubernetes.io/aws-load-balancer-type: external
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: ip
      service.beta.kubernetes.io/aws-load-balancer-proxy-protocol: "*"
      service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout: '3600'
    {{ end }}
  {{ end }}
{{ if $isGcp }}
  serviceAccount:
    annotations:
      iam.gke.io/gcp-service-account: {{ importValue "Terraform" "gcp_sa_workload_identity_email" }}
{{ end }}
