global:
  application:
    links:
    - description: rook web ui
      url: {{ .Values.hostname }}
rook-ceph-cluster:
  ingress:
    dashboard:
      annotations:
        cert-manager.io/cluster-issuer: letsencrypt-prod
        kubernetes.io/ingress.class: nginx
        kubernetes.io/tls-acme: "true"
        nginx.ingress.kubernetes.io/ssl-passthrough: "false"
        nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
        nginx.ingress.kubernetes.io/server-snippet: |
          proxy_ssl_verify off;
      host:
        name: {{ .Values.hostname }}
        path: /
      tls:
      - secretName: ceph-dashboard-tls-certificate
        hosts:
          - {{ .Values.hostname }}
s3Hostname: {{ .Values.s3Hostname }}
