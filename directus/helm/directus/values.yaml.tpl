{{ $hostname := default "example.com" .Values.hostname }}

{{ $key := dedupe . "directus.env.key" (uuidv4) }}
{{ $secret := dedupe . "directus.env.secret" (uuidv4) }}

global:
  application:
    links:
    - description: directus web ui
      url: {{ $hostname }}

env:
  PUBLIC_URL: https://{{ $hostname }}
  KEY: {{ $key }}
  SECRET: {{ $secret }}

ingress:
  enabled: true
  className: "nginx"
  annotations:
    kubernetes.io/tls-acme: "true"
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
  - host: {{ $hostname }}
    paths:
      - path: '/'
        pathType: ImplementationSpecific
  tls:
  - secretName: directus-tls
    hosts:
      - {{ $hostname }}