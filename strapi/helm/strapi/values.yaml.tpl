global:
  application:
    links:
    - description: strapi web ui
      url: {{ .Values.hostname }}

ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: strapi-tls
     hosts:
       - {{ .Values.hostname }}