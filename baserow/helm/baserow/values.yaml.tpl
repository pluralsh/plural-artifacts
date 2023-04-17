{{ $hostname := default "example.com" .Values.hostname }}
global:
  application:
    links:
    - description: baserow instance
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: baserow-tls
     hosts:
       - {{ $hostname }}