{{ $hostname := default "example.com" .Values.hostname }}

{{ $key := dedupe . "directus.env.key" (uuidv4) }}
{{ $secret := dedupe . "directus.env.secret" (uuidv4) }}

{{ $directusPgPwd := dedupe . "directus.postgres.password" (randAlphaNum 20) }}
{{ $directusPgDsn := default (printf "postgresql://directus:%s@plural-postgres-directus:5432/directus" $directusPgPwd) .Values.directusDsn }}

global:
  application:
    links:
    - description: directus web ui
      url: {{ $hostname }}

postgres:
  password: {{ $directusPgPwd }}
  dsn: {{ $directusPgDsn }}

env:
  PUBLIC_URL: https://{{ $hostname }}

directus:
  key: {{ $key }}
  secret: {{ $secret }}

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
