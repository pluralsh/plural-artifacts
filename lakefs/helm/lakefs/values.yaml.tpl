{{ $hostname := default "example.com" .Values.hostname }}
global:
  application:
    links:
    - description: lakefs web ui
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: lakefs-tls
     hosts:
       - {{ $hostname }}