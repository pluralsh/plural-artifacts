{{ $hostname := default "example.com" .Values.hostname }}

{{ $key := dedupe . "directus.env.key" (randAlphaNum 20) }}
{{ $secret := dedupe . "directus.env.secret" (randAlphaNum 20) }}

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
  {{ if .OIDC }}
  AUTH_PROVIDERS: plural
  AUTH_PLURAL_DRIVER: openid
  AUTH_PLURAL_SCOPE: openid profile
  AUTH_PLURAL_ALLOW_PUBLIC_REGISTRATION: true
  {{ end }}

directus:
  key: {{ $key }}
  secret: {{ $secret }}
  {{ if .OIDC }}
  oidc:
    enabled: true
    clientId: {{ .OIDC.ClientId }}
    clientSecret: {{ .OIDC.ClientSecret }}
    issuer: {{ .OIDC.Configuration.Issuer }}
  {{ end }}

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