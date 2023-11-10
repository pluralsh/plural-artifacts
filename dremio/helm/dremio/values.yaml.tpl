dremio:
  ingress:
    tls:
      - hosts:
          - { { .Values.hostname } }
        secretName: dremio-tls
    hosts:
      - { { .Values.hostname } }