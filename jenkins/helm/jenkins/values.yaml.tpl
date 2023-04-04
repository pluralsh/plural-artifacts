{{ $hostname := default "example.com" .Values.hostname }}
global:
  application:
    links:
    - description: jenkins instance
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: jenkins-tls
     hosts:
       - {{ $hostname }}