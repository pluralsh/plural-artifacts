{{ $hostname := default "example.com" .Values.hostname }}
global:
  application:
    links:
    - description: tier instance
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: tier-tls
     hosts:
       - {{ $hostname }}
