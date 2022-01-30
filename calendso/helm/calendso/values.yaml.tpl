global:
  application:
    links:
    - description: calendso web ui
      url: {{ .Values.hostname }}

{{ $postgresPwd := dedupe . "calendso.postgres.password" (randAlphaNum 25) }}

postgres:
  password: {{ $postgresPwd }}

ingress:
  tls:
  - hosts:
    - {{ .Values.hostname }}
    secretName: calendso-tls
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: '/.*'
      pathType: ImplementationSpecific

secrets:
  databaseUrl: postgres://calendso:{{ $postgresPwd }}@plural-calendso:5432/calendso?sslmode=require
  baseUrl: https://{{ .Values.hostname }}
  jwtSecret: {{ randAlphaNum 32 }}
  calendsoEncryptionKey: {{ randAlphaNum 32 }}