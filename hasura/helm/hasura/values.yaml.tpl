{{ $postgresPwd := dedupe . "hasura.hasura.pgClient.password" (randAlphaNum 25) }}

postgres:
  password: {{ $postgresPwd }}

ingress:
  host: {{ .Values.hostname }}

hasura:
  adminSecret: {{ dedupe . "hasura.hasura.adminSecret" (randAlphaNum 25) }}
  jwt:
    key: {{ dedupe . "hasura.hasura.jwt.key" (randAlphaNum 26) }}
  pgClient:
    external: true
    host: plural-hasura
    port: 5432
    username: hasura
    database: hasura
    password: {{ $postgresPwd }}