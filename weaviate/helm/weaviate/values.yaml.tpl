ingress:
  hosts:
  - host: {{ .Values.hostname }}
    paths:
      - path: '/'
        pathType: ImplementationSpecific
  tls:
  - secretName: weaviate-tls
    hosts:
      - {{ .Values.hostname }}
