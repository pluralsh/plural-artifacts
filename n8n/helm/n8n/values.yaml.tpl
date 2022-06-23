global:
  application:
    links:
    - description: n8n web ui
      url: {{ .Values.hostname }}

ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: n8n-tls
     hosts:
       - {{ .Values.hostname }}