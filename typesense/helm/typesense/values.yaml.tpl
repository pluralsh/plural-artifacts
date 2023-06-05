{{ $hostname := default "typesense.dev.plural.sh" .Values.hostname }}

global:
  application:
    links:
    - description: typesense instance
      url: {{ $hostname }}

ingress:
  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: typesense-tls
     hosts:
       - {{ $hostname }}

secretEnvs:
  TYPESENSE_API_KEY: {{ dedupe . "typesense.apiKey" (randAlphaNum 26) }}
