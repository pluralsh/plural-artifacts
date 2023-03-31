{{ $hostname := default "example.com" .Values.hostname }}

global:
  application:
    links:
    - description: jupyterhub instance
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: jupyterhub-tls
     hosts:
       - {{ $hostname }}
