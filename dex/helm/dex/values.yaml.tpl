dex:
  config:
    issuer: {{ .Values.fqdn }}
  
  ingress:
    hosts:
    - host: {{ .Values.fqdn }}
      paths:
      - path: /.*
    tls:
    - hosts:
      - {{ .Values.fqdn }}
      secretName: dex-cert