{{ $hostname := default "example.com" .Values.hostname }}
global:
  application:
    links:
    - description: strapi web ui
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: strapi-tls
     hosts:
       - {{ $hostname }}