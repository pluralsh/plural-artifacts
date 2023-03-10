sftpgo:
  ui:
    ingress:
      hosts:
      - host: {{ .Values.hostname }}
        paths:
          - path: '/.*'
            pathType: ImplementationSpecific
      tls:
      - secretName: sftpgo-tls
        hosts:
          - {{ .Values.hostname }}