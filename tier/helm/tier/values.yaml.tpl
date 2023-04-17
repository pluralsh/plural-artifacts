{{ $hostname := default "example.com" .Values.hostname }}
{{ $stripeLive := .Values.stripe_live }}
{{ $stripeApiKey := .Values.stripe_api_key }}

global:
  application:
    links:
    - description: tier instance
      url: {{ $hostname }}

tier:
  live: {{ $stripeLive }}
  basicAuth: {{ dedupe . "tier.basicAuth" (randAlphaNum 26) }}

ingress:
  annotations:
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: tier-ingress-basic-auth
    nginx.ingress.kubernetes.io/auth-realm: "Authentication Required"

  hosts:
   - host: {{ $hostname }}
     paths:
       - path: /
         pathType: ImplementationSpecific
  tls:
   - secretName: tier-tls
     hosts:
       - {{ $hostname }}

secretEnvs:
  STRIPE_API_KEY: {{ $stripeApiKey }}
