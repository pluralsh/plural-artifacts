global:
  application:
    links:
    - description: lightdash web ui
      url: {{ .Values.hostname }}

ingress:
  hosts:
   - host: {{ .Values.hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: lightdash-tls
     hosts:
       - {{ .Values.hostname }}