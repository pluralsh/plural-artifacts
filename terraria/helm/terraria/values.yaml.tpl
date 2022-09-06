ingress:
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: /
      pathType: ImplementationSpecific
  tls:
  - secretName: terraria-tls
    hosts:
    - {{ .Values.hostname }}
