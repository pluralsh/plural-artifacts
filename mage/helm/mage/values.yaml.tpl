{{ $hostname := default "example.com" .Values.hostname }}

{{ $magePgPwd := dedupe . "mage.postgres.password" (randAlphaNum 20) }}
{{ $mageJwtSecret := dedupe . "mage.jwt.secret" (randAlphaNum 20) }}
{{ $magePgDsn := default (printf "postgresql+psycopg2://mage:%s@plural-postgres-mage:5432/mage?sslmode=allow" $magePgPwd) .Values.mageDsn }}

global:
  application:
    links:
    - description: mage web ui
      url: {{ $hostname }}

postgres:
  password: {{ $magePgPwd }}
  dsn: {{ $magePgDsn }}

jwt:
  secret: {{ $mageJwtSecret }}

mageai:
  ingress:
    hosts:
    - host: {{ $hostname }}
      paths:
        - path: '/'
          pathType: ImplementationSpecific
    tls:
    - secretName: mage-tls
      hosts:
        - {{ $hostname }}

  env:
  - name: MAGE_DATABASE_CONNECTION_URL
    valueFrom:
      secretKeyRef:
          name: mage-postgres-dsn
          key: dsn
  - name: REQUIRE_USER_AUTHENTICATION
    value: "1"
  - name: MAGE_PUBLIC_HOST
    value: {{ $hostname }}
  - name: JWT_SECRET
    value: {{ $mageJwtSecret }}