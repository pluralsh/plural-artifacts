{{ $postgresPwd := dedupe . "nocodb.postgres.password" (randAlphaNum 25) }}

postgres:
  password: {{ $postgresPwd }}

nocodb:
  databaseUrl: postgres://nocodb:{{ $postgresPwd }}@plural-nocodb:5432/nocodb?sslmode=require
  jwtSecret: {{ dedupe . "nocodb.nocodb.jwtSecret" (randAlphaNum 30) }}
  dbConfig:
    client: pg
    connection:
      host: plural-nocodb
      port: 5432
      user: nocodb
      password: {{ $postgresPwd }}
      database: nocodb
      ssl:
        rejectUnauthorized: false
      sslmode: require

ingress:
  enabled: true
  tls:
  - hosts:
    - {{ .Values.hostname }}
    secretName: nocodb-tls
  hosts:
  - host: {{ .Values.hostname }}
    paths:
    - path: '/.*'
      pathType: ImplementationSpecific
      