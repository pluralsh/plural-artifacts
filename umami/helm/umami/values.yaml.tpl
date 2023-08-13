{{ $hostname := default "example.com" .Values.hostname }}

{{ $umamiPgPwd := dedupe . "umami.postgres.password" (randAlphaNum 20) }}
{{ $umamiPgDsn := default (printf "postgresql://umami:%s@plural-postgres-umami:5432/umami?sslmode=allow" $umamiPgPwd) .Values.umamiDsn }}

{{ $hashSalt := dedupe . "umami.umami.umami.hash.salt" (randAlphaNum 20) }}

global:
  application:
    links:
    - description: umami web ui
      url: {{ $hostname }}

postgres:
  password: {{ $umamiPgPwd }}
  dsn: {{ $umamiPgDsn }}

umami:
  ingress:
    hosts:
    - host: {{ $hostname }}
      paths:
        - path: '/'
          pathType: ImplementationSpecific
    tls:
    - secretName: umami-tls
      hosts:
        - {{ $hostname }}
  umami:
    hostname: {{ $hostname }}
    hash:
      salt: {{ $hashSalt }}