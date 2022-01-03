{{ $postgresPwd := dedupe . "hasura.hasura.pgClient.password" (randAlphaNum 25) }}

postgres:
  password: {{ $postgresPwd }}

hasura:
  pgClient:
    external: true
    host: plural-hasura
    port: 5432
    username: hasura
    database: hasura
    password: {{ $postgresPwd }}