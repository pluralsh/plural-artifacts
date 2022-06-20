global:
  application:
    links:
    - description: trinodb web ui
      url: {{ .Values.hostname }}

ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: trinodb-tls
     hosts:
       - {{ .Values.hostname }}